From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 03/16] lib,
 treewide: add new match_string() helper/macro
Date: Wed, 8 May 2019 15:18:56 +0200
Message-ID: <20190508131856.GB10138@kroah.com>
References: <20190508112842.11654-1-alexandru.ardelean@analog.com>
 <20190508112842.11654-5-alexandru.ardelean@analog.com>
 <20190508131128.GL9224@smile.fi.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <intel-gfx-bounces@lists.freedesktop.org>
Content-Disposition: inline
In-Reply-To: <20190508131128.GL9224@smile.fi.intel.com>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/intel-gfx>,
 <mailto:intel-gfx-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/intel-gfx>
List-Post: <mailto:intel-gfx@lists.freedesktop.org>
List-Help: <mailto:intel-gfx-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/intel-gfx>,
 <mailto:intel-gfx-request@lists.freedesktop.org?subject=subscribe>
Errors-To: intel-gfx-bounces@lists.freedesktop.org
Sender: "Intel-gfx" <intel-gfx-bounces@lists.freedesktop.org>
Content-Type: text/plain; charset="us-ascii"
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: linux-fbdev@vger.kernel.org, kvm@vger.kernel.org, linux-pci@vger.kernel.org, alsa-devel@alsa-project.org, dri-devel@lists.freedesktop.org, linux-ide@vger.kernel.org, linux-mtd@lists.infradead.org, linux-clk@vger.kernel.org, devel@driverdev.osuosl.org, linux-rockchip@lists.infradead.org, linux-mmc@vger.kernel.org, Alexandru Ardelean <alexandru.ardelean@analog.com>, linux-pm@vger.kernel.org, intel-gfx@lists.freedesktop.org, linux-gpio@vger.kernel.org, linux-rpi-kernel@lists.infradead.org, linux-tegra@vger.kernel.org, cgroups@vger.kernel.org, linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, netdev@vger.kernel.org, linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-integrity@vger.kernel.org, linuxppc-dev@lists.ozlabs.org

T24gV2VkLCBNYXkgMDgsIDIwMTkgYXQgMDQ6MTE6MjhQTSArMDMwMCwgQW5keSBTaGV2Y2hlbmtv
IHdyb3RlOgo+IE9uIFdlZCwgTWF5IDA4LCAyMDE5IGF0IDAyOjI4OjI5UE0gKzAzMDAsIEFsZXhh
bmRydSBBcmRlbGVhbiB3cm90ZToKPiA+IFRoaXMgY2hhbmdlIHJlLWludHJvZHVjZXMgYG1hdGNo
X3N0cmluZygpYCBhcyBhIG1hY3JvIHRoYXQgdXNlcwo+ID4gQVJSQVlfU0laRSgpIHRvIGNvbXB1
dGUgdGhlIHNpemUgb2YgdGhlIGFycmF5Lgo+ID4gVGhlIG1hY3JvIGlzIGFkZGVkIGluIGFsbCB0
aGUgcGxhY2VzIHRoYXQgZG8KPiA+IGBtYXRjaF9zdHJpbmcoX2EsIEFSUkFZX1NJWkUoX2EpLCBz
KWAsIHNpbmNlIHRoZSBjaGFuZ2UgaXMgcHJldHR5Cj4gPiBzdHJhaWdodGZvcndhcmQuCj4gCj4g
Q2FuIHlvdSBzcGxpdCBpbmNsdWRlL2xpbnV4LyBjaGFuZ2UgZnJvbSB0aGUgcmVzdD8KClRoYXQg
d291bGQgYnJlYWsgdGhlIGJ1aWxkLCB3aHkgZG8geW91IHdhbnQgaXQgc3BsaXQgb3V0PyAgVGhp
cyBtYWtlcwpzZW5zZSBhbGwgYXMgYSBzaW5nbGUgcGF0Y2ggdG8gbWUuCgp0aGFua3MsCgpncmVn
IGstaApfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpJbnRl
bC1nZnggbWFpbGluZyBsaXN0CkludGVsLWdmeEBsaXN0cy5mcmVlZGVza3RvcC5vcmcKaHR0cHM6
Ly9saXN0cy5mcmVlZGVza3RvcC5vcmcvbWFpbG1hbi9saXN0aW5mby9pbnRlbC1nZng=
