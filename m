From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: remove dead bdi congestion leftovers
Date: Thu, 9 Jul 2020 07:32:33 +0200
Message-ID: <20200709053233.GA3243@lst.de>
References: <20200701090622.3354860-1-hch@lst.de>
	<b5d6df17-68af-d535-79e4-f95e16dd5632@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <b5d6df17-68af-d535-79e4-f95e16dd5632-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.linbit.com/mailman/options/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linbit.com/pipermail/drbd-dev>
List-Post: <mailto:drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
List-Help: <mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linbit.com/mailman/listinfo/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=subscribe>
Sender: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
Errors-To: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org

T24gV2VkLCBKdWwgMDgsIDIwMjAgYXQgMDU6MTQ6MjlQTSAtMDYwMCwgSmVucyBBeGJvZSB3cm90
ZToKPiBPbiA3LzEvMjAgMzowNiBBTSwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6Cj4gPiBIaSBK
ZW5zLAo+ID4gCj4gPiB3ZSBoYXZlIGEgbG90IG9mIGJkaSBjb25nZXN0aW9uIHJlbGF0ZWQgY29k
ZSB0aGF0IGlzIGxlZnQgYXJvdW5kIHdpdGhvdXQKPiA+IGFueSB1c2UuICBUaGlzIHNlcmllcyBy
ZW1vdmVzIGl0IGluIHByZXBhcmF0aW9uIG9mIHNvcnRpbmcgb3V0IHRoZSBiZGkKPiA+IGxpZmV0
aW1lIHJ1bGVzIHByb3Blcmx5Lgo+IAo+IFBsZWFzZSBydW4gc2VyaWVzIGxpa2UgdGhpcyB0aHJv
dWdoIGEgZnVsbCBjb21waWxhdGlvbiwgZm9yIGJvdGggdGhpcyBvbmUKPiBhbmQgdGhlIHByZXZp
b3VzIHNlcmllcyBJIGhhZCB0byBmaXggdXAgaXNzdWVzIGxpa2UgdGhpczoKPiAKPiBkcml2ZXJz
L21kL2JjYWNoZS9yZXF1ZXN0LmM6IEluIGZ1bmN0aW9uIOKAmGJjaF9jYWNoZWRfZGV2X3JlcXVl
c3RfaW5pdOKAmToKPiBkcml2ZXJzL21kL2JjYWNoZS9yZXF1ZXN0LmM6MTIzMzoxODogd2Fybmlu
ZzogdW51c2VkIHZhcmlhYmxlIOKAmGfigJkgWy1XdW51c2VkLXZhcmlhYmxlXQo+ICAxMjMzIHwg
IHN0cnVjdCBnZW5kaXNrICpnID0gZGMtPmRpc2suZGlzazsKPiAgICAgICB8ICAgICAgICAgICAg
ICAgICAgXgo+IGRyaXZlcnMvbWQvYmNhY2hlL3JlcXVlc3QuYzogSW4gZnVuY3Rpb24g4oCYYmNo
X2ZsYXNoX2Rldl9yZXF1ZXN0X2luaXTigJk6Cj4gZHJpdmVycy9tZC9iY2FjaGUvcmVxdWVzdC5j
OjEzMjA6MTg6IHdhcm5pbmc6IHVudXNlZCB2YXJpYWJsZSDigJhn4oCZIFstV3VudXNlZC12YXJp
YWJsZV0KPiAgMTMyMCB8ICBzdHJ1Y3QgZ2VuZGlzayAqZyA9IGQtPmRpc2s7Cj4gICAgICAgfCAg
ICAgICAgICAgICAgICAgIF4KPiAKPiBEaWQgdGhlIHNhbWUgaGVyZSwgYXBwbGllZCBpdC4KCkFu
ZCBqdXN0IGxpa2UgdGhlIHByZXZpb3VzIG9uZSBJIGRpZCwgYW5kIHRoZSBjb21waWxlciBkaWQg
bm90IGNvbXBsYWluLgpUaGVyZSBtdXN0IGJlIHNvbWV0aGluZyBhYm91dCBjZXJ0YWluIGdjYyB2
ZXJzaW9ucyBub3Qgd2FybmluZyBhYm91dAp2YXJpYWJsZXMgdGhhdCBhcmUgaW5pdGlhbGl6ZWQg
YnV0IG5vdCBvdGhlcndpc2UgdXNlZC4KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX18KZHJiZC1kZXYgbWFpbGluZyBsaXN0CmRyYmQtZGV2QGxpc3RzLmxpbmJp
dC5jb20KaHR0cHM6Ly9saXN0cy5saW5iaXQuY29tL21haWxtYW4vbGlzdGluZm8vZHJiZC1kZXYK
