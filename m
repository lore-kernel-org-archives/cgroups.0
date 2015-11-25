From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] cpuset: Replace all instances of time_t with
	time64_t
Date: Wed, 25 Nov 2015 14:01:50 -0500
Message-ID: <20151125190150.GA14240@htj.duckdns.org>
References: <2798266.9VZu01a7d1@wuerfel>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <y2038-bounces@lists.linaro.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
 h=sender:date:from:to:cc:subject:message-id:references:mime-version
 :content-type:content-disposition:in-reply-to:user-agent;
 bh=O/5JBa5EIhsYQ7FX2PG/qoEvzzorbkSjgWjlANNZsIk=;
 b=Dlh9g45ZZjTY6wwtGYc7AD/C61asVD7+lSP9/s3fRUM9fBwoQXbC2I5PNBkQmvDaxi
 SdwC8f85J4JXxkfd5ZBQnNKKm4D9W5IDFGH0cOY4WihHA2r3x4qkJCaPwwAIbYgQ7P2p
 MCC8lRRKtoRbxCsCzdK11Wmp9RJ/J4ZEYR+qesbx3IZgvcVryyKH8hyOLaeWsNza0LsR
 NYN45IxdHSco2Z79HVQ1tJqNiTq7lSs6zgwcJlNv3Pk3MUCLwgKi8OpCp7NRwBHP14vM
 Szhgi+HduksxyfVfmsxf/kScMELgwl9fmXzznt8AQETpePju98i6msEYTG3PilsChd0w
 CYJQ==
Content-Disposition: inline
In-Reply-To: <2798266.9VZu01a7d1@wuerfel>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.linaro.org/mailman/options/y2038>,
 <mailto:y2038-request@lists.linaro.org?subject=unsubscribe>
List-Archive: <http://lists.linaro.org/pipermail/y2038/>
List-Post: <mailto:y2038@lists.linaro.org>
List-Help: <mailto:y2038-request@lists.linaro.org?subject=help>
List-Subscribe: <https://lists.linaro.org/mailman/listinfo/y2038>,
 <mailto:y2038-request@lists.linaro.org?subject=subscribe>
Errors-To: y2038-bounces@lists.linaro.org
Sender: "Y2038" <y2038-bounces@lists.linaro.org>
Content-Type: text/plain; charset="us-ascii"
To: Arnd Bergmann <arnd@arndb.de>
Cc: y2038@lists.linaro.org, linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>, John Stultz <john.stultz@linaro.org>, cgroups@vger.kernel.org, tglx@linutronix.de, Heena Sirwani <heenasirwani@gmail.com>

T24gV2VkLCBOb3YgMjUsIDIwMTUgYXQgMDQ6MTY6NTVQTSArMDEwMCwgQXJuZCBCZXJnbWFubiB3
cm90ZToKPiBUaGUgZm9sbG93aW5nIHBhdGNoIHJlcGxhY2VzIGFsbCBpbnN0YW5jZXMgb2YgdGlt
ZV90IHdpdGggdGltZTY0X3QgaS5lLgo+IGNoYW5nZSB0aGUgdHlwZSB1c2VkIGZvciByZXByZXNl
bnRpbmcgdGltZSBmcm9tIDMyLWJpdCB0byA2NC1iaXQuIEFsbAo+IDMyLWJpdCBrZXJuZWxzIHRv
IGRhdGUgdXNlIGEgc2lnbmVkIDMyLWJpdCB0aW1lX3QgdHlwZSwgd2hpY2ggY2FuIG9ubHkKPiBy
ZXByZXNlbnQgdGltZSB1bnRpbCBKYW51YXJ5IDIwMzguIFNpbmNlIGVtYmVkZGVkIHN5c3RlbXMg
cnVubmluZyAzMi1iaXQKPiBMaW51eCBhcmUgZ29pbmcgdG8gc3Vydml2ZSBiZXlvbmQgdGhhdCBk
YXRlLCB3ZSBoYXZlIHRvIGNoYW5nZSBhbGwKPiBjdXJyZW50IHVzZXMsIGluIGEgYmFja3dhcmRz
IGNvbXBhdGlibGUgd2F5Lgo+IAo+IFRoZSBwYXRjaCBhbHNvIGNoYW5nZXMgdGhlIGZ1bmN0aW9u
IGdldF9zZWNvbmRzKCkgdGhhdCByZXR1cm5zIGEgMzItYml0Cj4gaW50ZWdlciB0byBrdGltZV9n
ZXRfc2Vjb25kcygpIHRoYXQgcmV0dXJucyBzZWNvbmRzIGFzIDY0LWJpdCBpbnRlZ2VyLgo+IAo+
IFRoZSBwYXRjaCBjaGFuZ2VzIHRoZSB0eXBlIG9mIHRpY2tzIGZyb20gdGltZV90IHRvIHUzMi4g
V2Uga2VlcCB0aWNrcyBhcwo+IDMyLWJpdHMgYXMgdGhlIGZ1bmN0aW9uIHVzZXMgMzItYml0IGFy
aXRobWV0aWMgd2hpY2ggd291bGQgcHJvdmUgbGVzcwo+IGV4cGVuc2l2ZSB0aGFuIDY0LWJpdCBh
cml0aG1ldGljIGFuZCB0aGUgZnVuY3Rpb24gaXMgZXhwZWN0ZWQgdG8gYmUKPiBjYWxsZWQgYXRs
ZWFzdCBvbmNlIGV2ZXJ5IDMyIHNlY29uZHMuCj4gCj4gU2lnbmVkLW9mZi1ieTogSGVlbmEgU2ly
d2FuaSA8aGVlbmFzaXJ3YW5pQGdtYWlsLmNvbT4KPiBSZXZpZXdlZC1ieTogQXJuZCBCZXJnbWFu
biA8YXJuZEBhcm5kYi5kZT4KPiBTaWduZWQtb2ZmLWJ5OiBBcm5kIEJlcmdtYW5uIDxhcm5kQGFy
bmRiLmRlPgoKQXBwbGllZCB0byBjZ3JvdXAvZm9yLTQuNS4KClRoYW5rcy4KCi0tIAp0ZWp1bgpf
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpZMjAzOCBtYWls
aW5nIGxpc3QKWTIwMzhAbGlzdHMubGluYXJvLm9yZwpodHRwczovL2xpc3RzLmxpbmFyby5vcmcv
bWFpbG1hbi9saXN0aW5mby95MjAzOAo=
