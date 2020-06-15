From: David Laight <David.Laight@ACULAB.COM>
Subject: RE: [PATCH v3 1/4] fs, net: Standardize on file_receive helper to
 move fds across processes
Date: Mon, 15 Jun 2020 08:27:24 +0000
Message-ID: <e54c39728d944de782394f4632bc7b1e@AcuMS.aculab.com>
References: <202006092227.D2D0E1F8F@keescook>
 <20200610081237.GA23425@ircssh-2.c.rugged-nimbus-611.internal>
 <202006101953.899EFB53@keescook>
 <20200611100114.awdjswsd7fdm2uzr@wittgenstein>
 <20200611110630.GB30103@ircssh-2.c.rugged-nimbus-611.internal>
 <067f494d55c14753a31657f958cb0a6e@AcuMS.aculab.com>
 <202006111634.8237E6A5C6@keescook>
 <94407449bedd4ba58d85446401ff0a42@AcuMS.aculab.com>
 <20200612104629.GA15814@ircssh-2.c.rugged-nimbus-611.internal>
 <202006120806.E770867EF@keescook>
 <20200612182816.okwylihs6u6wkgxd@wittgenstein>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20200612182816.okwylihs6u6wkgxd@wittgenstein>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: 'Christian Brauner' <christian.brauner@ubuntu.com>, Kees Cook <keescook@chromium.org>
Cc: Sargun Dhillon <sargun@sargun.me>, Giuseppe Scrivano <gscrivan@redhat.com>, Robert Sesek <rsesek@google.com>, Chris Palmer <palmer@google.com>, Jann Horn <jannh@google.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "containers@lists.linux-foundation.org" <containers@lists.linux-foundation.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Matt Denton <mpdenton@google.com>, Tejun Heo <tj@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "David S . Miller" <davem@davemloft.net>

RnJvbTogQ2hyaXN0aWFuIEJyYXVuZXINCj4gU2VudDogMTIgSnVuZSAyMDIwIDE5OjI4DQouLi4N
Cj4gPiA+IAlpZiAoc2l6ZSA8IDMyKQ0KPiA+ID4gCQlyZXR1cm4gLUVJTlZBTDsNCj4gPiA+IAlp
ZiAoc2l6ZSA+IFBBR0VfU0laRSkNCj4gPiA+IAkJcmV0dXJuIC1FMkJJRzsNCj4gPg0KPiA+IChU
YW5nZXQ6IHdoYXQgd2FzIHRoZSByZWFzb24gZm9yIGNvcHlfc3RydWN0X2Zyb21fdXNlcigpIG5v
dCBpbmNsdWRpbmcNCj4gPiB0aGUgbWluL21heCBjaGVjaz8gSSBoYXZlIGEgbWVtb3J5IG9mIEFs
IG9iamVjdGluZyB0byBoYXZpbmcgYW4NCj4gPiAiaW50ZXJuYWwiIGxpbWl0PykNCj4gDQo+IEFs
IGRpZG4ndCB3YW50IHRoZSBQQUdFX1NJWkUgbGltaXQgaW4gdGhlcmUgYmVjYXVzZSB0aGVyZSdz
IG5vdGhpbmcNCj4gaW5oZXJlbnRseSB3cm9uZyB3aXRoIGNvcHlpbmcgaW5zYW5lIGFtb3VudHMg
b2YgbWVtb3J5Lg0KDQpUaGUgcHJvYmxlbSBpcyByZWFsbHkgYWxsb3dpbmcgYSB1c2VyIHByb2Nl
c3MgdG8gYWxsb2NhdGUNCnVuYm91bmRlZCBibG9ja3Mgb2YgbWVtb3J5LCBub3QgdGhlIGNvcHkg
aXRzZWxmLg0KDQpUaGUgbGltaXQgZm9yIElPVygpIGV0YyBpcyAxNmsgLSBub3QgYSBwcm9ibGVt
Lg0KSWYgYSAzMmJpdCBzaXplIGlzIHNldCB0byBqdXN0IHVuZGVyIDRHQiBzbyB5b3UgcmVhbGx5
IHdhbnQNCnRvIGFsbG9jYXRlIDRHQiBvZiBtZW1vcnkgdGhlbiBmaW5kIHRoZSByZXF1ZXN0IGlz
IGdhcmJhZ2UuDQpTZWVtcyBsaWtlIGEgbmljZSBEb1MgYXR0YWNrLg0KQSA2NGJpdCBzaXplIGNh
biBiZSB3b3JzZS4NCg0KUG90ZW50aWFsbHkgdGhlIGxpbWl0IHNob3VsZCBiZSBpbiBtZW1kdXBf
dXNlcigpIGl0c2VsZi4NCkFuZCBwb3NzaWJseSBhbiBleHRyYSBwYXJhbWV0ZXIgZ2l2aW5nIGEg
cGVyLWNhbGwgbG93ZXI/IGxpbWl0Lg0KDQoJRGF2aWQNCg0KLQ0KUmVnaXN0ZXJlZCBBZGRyZXNz
IExha2VzaWRlLCBCcmFtbGV5IFJvYWQsIE1vdW50IEZhcm0sIE1pbHRvbiBLZXluZXMsIE1LMSAx
UFQsIFVLDQpSZWdpc3RyYXRpb24gTm86IDEzOTczODYgKFdhbGVzKQ0K

