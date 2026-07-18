#Maintained by @s0m3guy2004 on GitHub, you can contact me at @s0m3sushi via Discord

EAPI=8
#Inheriting these for refreshing icon cache
inherit desktop xdg
DESCRIPTION="Coc Coc is a browser that combines a minimal design with sophisticated technology to make the web faster, safer, and easier."
HOMEPAGE="https://github.com/s0m3guy2004/coccoc-gentoo"
SRC_URI="https://browser-linux.coccoc.com/deb/pool/main/${PN}-stable_${PV}-1_amd64.deb"
S="${WORKDIR}" 
LICENSE="custom"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
RDEPEND="
	>=app-accessibility/at-spi2-core-2.46.0:2
	app-misc/ca-certificates
	dev-libs/expat
	dev-libs/glib:2
	dev-libs/nspr
	>=dev-libs/nss-3.26
	media-fonts/liberation-fonts
	media-libs/alsa-lib
	media-libs/mesa
	media-libs/vulkan-loader
	net-misc/curl
	net-print/cups
	sys-apps/dbus
	sys-libs/glibc
	virtual/libudev
	x11-libs/cairo
	x11-libs/gtk+:3
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXrandr
	x11-libs/libxcb
	x11-libs/libdrm
	x11-libs/libxshmfence
	x11-libs/libxkbcommon
	x11-libs/pango
	x11-misc/xdg-utils"
RESTRICT="strip"
BDEPEND="app-arch/xz-utils"

src_unpack() {
    default
    unpack "./data.tar.xz"
}

src_install() {
    # Remove it's daily cron jobs from /opt.
    rm -r ${WORKDIR}/opt/coccoc/browser/cron || die 

    # Uncompress man docs
    gzip -d ${WORKDIR}/usr/share/doc/${PN}-stable/changelog.gz || die
    gzip -d ${WORKDIR}/usr/share/man/man1/${PN}-stable.1.gz || die
    if [[ -L ${WORKDIR}/usr/share/man/man1/${PN}.1.gz ]]; then
    rm ${WORKDIR}/usr/share/man/man1/${PN}.1.gz || die
    dosym ${PN}.1 ${WORKDIR}/usr/share/man/man1/${PN}.1
    fi

    # Move metainfo to the updated directory.
    mv ${WORKDIR}/usr/share/appdata ${WORKDIR}/usr/share/metainfo

    # Adding version number to /usr/share/doc/coccoc-stable.
    mv ${WORKDIR}/usr/share/doc/coccoc-browser-stable ${WORKDIR}/usr/share/doc/${PF}

    # Get High-DPI icons.
    local icon_sizes=(16 24 32 48 64 128 256)
    for size in "${icon_sizes[@]}"; do
        install -Dm644 "${WORKDIR}/opt/coccoc/browser/product_logo_${size}.png" \
        "${WORKDIR}/usr/share/icons/hicolor/${size}x${size}/apps/coccoc-browser.png"
        rm "${WORKDIR}/opt/coccoc/browser/product_logo_${size}.png"
    done

    # Copy to image.
    cp -a ${WORKDIR}/usr "${ED}"/ || die
    cp -a ${WORKDIR}/opt "${ED}"/ || die

    # Remove unneeded /var.
    rm -r ${ED}/var || die
}
