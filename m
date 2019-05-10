From: "andriy.shevchenko@linux.intel.com" <andriy.shevchenko@linux.intel.com>
Subject: Re: [PATCH 03/16] lib,
 treewide: add new match_string() helper/macro
Date: Fri, 10 May 2019 17:34:07 +0300
Message-ID: <20190510143407.GA9224@smile.fi.intel.com>
References: <20190508112842.11654-1-alexandru.ardelean@analog.com>
 <20190508112842.11654-5-alexandru.ardelean@analog.com>
 <20190508131128.GL9224@smile.fi.intel.com>
 <20190508131856.GB10138@kroah.com>
 <b2440bc9485456a7a90a488c528997587b22088b.camel@analog.com>
 <4df165bc4247e60aa4952fd55cb0c77e60712767.camel@analog.com>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <intel-gfx-bounces@lists.freedesktop.org>
Content-Disposition: inline
In-Reply-To: <4df165bc4247e60aa4952fd55cb0c77e60712767.camel@analog.com>
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
To: "Ardelean, Alexandru" <alexandru.Ardelean@analog.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>, "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>, "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>, "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>, "linux-rockchip@lists.infradead.org" <linux-rockchip@lists.infradead.org>, "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>, "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>, "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>, "linux-rpi-kernel@lists.infradead.org" <>

T24gRnJpLCBNYXkgMTAsIDIwMTkgYXQgMDk6MTU6MjdBTSArMDAwMCwgQXJkZWxlYW4sIEFsZXhh
bmRydSB3cm90ZToKPiBPbiBXZWQsIDIwMTktMDUtMDggYXQgMTY6MjIgKzAzMDAsIEFsZXhhbmRy
dSBBcmRlbGVhbiB3cm90ZToKPiA+IE9uIFdlZCwgMjAxOS0wNS0wOCBhdCAxNToxOCArMDIwMCwg
R3JlZyBLSCB3cm90ZToKPiA+ID4gT24gV2VkLCBNYXkgMDgsIDIwMTkgYXQgMDQ6MTE6MjhQTSAr
MDMwMCwgQW5keSBTaGV2Y2hlbmtvIHdyb3RlOgo+ID4gPiA+IE9uIFdlZCwgTWF5IDA4LCAyMDE5
IGF0IDAyOjI4OjI5UE0gKzAzMDAsIEFsZXhhbmRydSBBcmRlbGVhbiB3cm90ZToKCj4gPiA+ID4g
Q2FuIHlvdSBzcGxpdCBpbmNsdWRlL2xpbnV4LyBjaGFuZ2UgZnJvbSB0aGUgcmVzdD8KPiA+ID4g
Cj4gPiA+IFRoYXQgd291bGQgYnJlYWsgdGhlIGJ1aWxkLCB3aHkgZG8geW91IHdhbnQgaXQgc3Bs
aXQgb3V0PyAgVGhpcyBtYWtlcwo+ID4gPiBzZW5zZSBhbGwgYXMgYSBzaW5nbGUgcGF0Y2ggdG8g
bWUuCj4gPiA+IAo+ID4gCj4gPiBOb3QgcmVhbGx5Lgo+ID4gSXQgd291bGQgYmUganVzdCBiZSB0
aGUgbmV3IG1hdGNoX3N0cmluZygpIGhlbHBlci9tYWNybyBpbiBhIG5ldyBjb21taXQuCj4gPiBB
bmQgdGhlIGNvbnZlcnNpb25zIG9mIHRoZSBzaW1wbGUgdXNlcnMgb2YgbWF0Y2hfc3RyaW5nKCkg
KHRoZSBvbmVzIHVzaW5nCj4gPiBBUlJBWV9TSVpFKCkpIGluIGFub3RoZXIgY29tbWl0Lgo+ID4g
Cj4gCj4gSSBzaG91bGQgaGF2ZSBhc2tlZCBpbiBteSBwcmV2aW91cyByZXBseS4KPiBMZWF2ZSB0
aGlzIGFzLWlzIG9yIHJlLWZvcm11bGF0ZSBpbiAyIHBhdGNoZXMgPwoKRGVwZW5kcyBvbiBvbiB3
aGF0IHlvdSB3b3VsZCBsaWtlIHRvIHNwZW5kIHlvdXIgdGltZTogY29sbGVjdGluZyBBY2tzIGZv
ciBhbGwKcGllY2VzIGluIHRyZWV3aWRlIHBhdGNoIG9yIHNlbmQgbmV3IEFQSSBmaXJzdCBmb2xs
b3dlZCB1cCBieSBwZXIgZHJpdmVyIC8KbW9kdWxlIHVwZGF0ZSBpbiBuZXh0IGN5Y2xlLgoKSSBh
bHNvIGhhdmUgbm8gc3Ryb25nIHByZWZlcmVuY2UuCkFuZCBJIHRoaW5rIGl0J3MgZ29vZCB0byBh
ZGQgSGVpa2tpIEtyb2dlcnVzIHRvIENjIGxpc3QgZm9yIGJvdGggcGF0Y2ggc2VyaWVzLApzaW5j
ZSBoZSBpcyB0aGUgYXV0aG9yIG9mIHN5c2ZzIHZhcmlhbnQgYW5kIG1heSBoYXZlIHNvbWV0aGlu
ZyB0byBjb21tZW50IG9uCnRoZSByZXN0LgoKLS0gCldpdGggQmVzdCBSZWdhcmRzLApBbmR5IFNo
ZXZjaGVua28KCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
XwpJbnRlbC1nZnggbWFpbGluZyBsaXN0CkludGVsLWdmeEBsaXN0cy5mcmVlZGVza3RvcC5vcmcK
aHR0cHM6Ly9saXN0cy5mcmVlZGVza3RvcC5vcmcvbWFpbG1hbi9saXN0aW5mby9pbnRlbC1nZng=
