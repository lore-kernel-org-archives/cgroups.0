From: teawater <teawaterz@linux.alibaba.com>
Subject: Re: [PATCH] mm: vmscan: memcg: Add global shrink priority
Date: Mon, 30 Dec 2019 11:32:36 +0800
Message-ID: <07AF5F95-23CB-4A7E-A9DA-8F67E22A7195@linux.alibaba.com>
References: <1576662179-16861-1-git-send-email-teawaterz@linux.alibaba.com>
 <20191218140952.GA255739@chrisdown.name>
 <25AA9500-B249-42C2-B162-2B8D4EE83BB0@linux.alibaba.com>
 <20191219112618.GA72828@chrisdown.name>
 <1E6A7BC4-A983-4C65-9DA9-4D3A26D4D31D@linux.alibaba.com>
 <20191229140240.GB612003@chrisdown.name>
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191229140240.GB612003@chrisdown.name>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="gb2312"
To: Chris Down <chris@chrisdown.name>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Shakeel Butt <shakeelb@google.com>, Yang Shi <yang.shi@linux.alibaba.com>, tj@kernel.org, tglx@linutronix.de, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org

Cgo+INTaIDIwMTnE6jEy1MIyOcjVo6wyMjowMqOsQ2hyaXMgRG93biA8Y2hyaXNAY2hyaXNkb3du
Lm5hbWU+INC0tcCjugo+IAo+IEhpIEh1aSwKPiAKPiB0ZWF3YXRlciB3cml0ZXM6Cj4+IEluIHRo
ZSBtZW1vcnktY29uc3RyYWluZWQgYW5kIGNvbXBsZXggbXVsdGl0YXNraW5nIGVudmlyb25tZW50
IHN1Y2ggYXMgYW4gQW5kcm9pZCBzeXN0ZW0gbWF5IHJlcXVpcmUgbW9yZSBjb21wbGV4IHBlcmZv
cm1hbmNlIHByaW9yaXR5Lgo+PiBGb3IgZXhhbXBsZSwgdGhlIHRhc2tzIG9mIGFwcCBpbiB0aGUg
Zm9udCwgdGhleSBuZWVkIGhpZ2ggcHJpb3JpdHkgYmVjYXVzZSBsb3cgcHJpb3JpdHkgd2lsbCBh
ZmZlY3QgdGhlIHVzZXIgZXhwZXJpZW5jZSBhdCBvbmNlLgo+PiBUaGUgdGFza3Mgb2YgYXBwIGlu
IGJhY2tncm91bmQgc2hvdWxkIGhhdmUgbG93ZXIgcHJpb3JpdHkgdGhhbiB0aGUgZmlyc3Qgb25l
LiAgQW5kIHNvbWV0aW1lLCBlYWNoIGFwcCBzaG91bGQgaGF2ZSBkaWZmZXJlbnQgcHJpb3JpdHku
ICBCZWNhdXNlIHNvbWUgYXBwcyBhcmUgZnJlcXVlbnRseSB1c2VkLiAgVGhleSBzaG91bGQgaGF2
ZSBoaWdoIHByaW9yaXR5IHRoYW4gb3RoZXIgYmFja2dyb3VuZCBhcHBzLgo+PiBUaGUgZGFlbW9u
cyBzaG91bGQgaGF2ZSBsb3dlciBwcmlvcml0eSB0aGFuIGJhY2tncm91bmQgYXBwcy4gIEJlY2F1
c2UgbW9zdCBvZiB0aGVtIHdpbGwgbm90IGFmZmVjdCB0aGUgdXNlciBleHBlcmllbmNlLgo+IAo+
IEluIGdlbmVyYWwgSSBkb24ndCB0aGluayBpdCdzIG1lYW5pbmdmdWwgdG8gc3BlY3VsYXRlIGFi
b3V0IHdoZXRoZXIgaXQgd291bGQgaGVscCBvciBub3Qgd2l0aG91dCBkYXRhIGFuZCBldmlkZW5j
ZSBnYXRoZXJpbmcuIEl0IHdvdWxkIHJlYWxseSBkZXBlbmQgb24gaG93IHRoZSBzeXN0ZW0gaXMg
Y29tcG9zZWQgb3ZlcmFsbC4gSXMgdGhpcyBhIHJlYWwgcHJvYmxlbSB5b3UncmUgc2VlaW5nLCBv
ciBqdXN0IHNvbWV0aGluZyBoeXBvdGhldGljYWw/Cj4gCj4gSWYgdGhlcmUgaXMgYSByZWFsIGNh
c2UgdG8gZGlzY3Vzcywgd2UgY2FuIGNlcnRhaW5seSBkaXNjdXNzIGl0LiBUaGF0IHNhaWQsIGF0
IHRoZSB2ZXJ5IGxlYXN0IEkgdGhpbmsgdGhlIEFQSSBuZWVkcyB0byBiZSBlYXNpZXIgdG8gcmVh
c29uIGFib3V0IHJhdGhlciB0aGFuIGp1c3QgZXhwb3NpbmcgbW0gaW50ZXJuYWxzLCBhbmQgdGhl
cmUgbmVlZHMgdG8gYmUgYSBkZW1vbnN0cmF0aW9uIHRoYXQgaXQgc29sdmVzIGEgcmVhbCBwcm9i
bGVtIGFuZCBleGlzdGluZyBjb250cm9scyBhcmUgaW5zdWZmaWNpZW50IDotKQo+IAo+IFRoYW5r
cywKPiAKPiBDaHJpcwoKVGhhbmtzISAgQWdyZWUgd2l0aCB5b3UuCgpCZXN0LApIdWkK
