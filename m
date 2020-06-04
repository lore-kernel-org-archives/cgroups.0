From: David Laight <David.Laight@ACULAB.COM>
Subject: RE: [PATCH v3 1/4] fs, net: Standardize on file_receive helper to
 move fds across processes
Date: Thu, 4 Jun 2020 13:28:02 +0000
Message-ID: <f1b77cafef8c4d159b1daa9cd4a06794@AcuMS.aculab.com>
References: <20200603011044.7972-1-sargun@sargun.me>
 <20200603011044.7972-2-sargun@sargun.me>
 <20200604012452.vh33nufblowuxfed@wittgenstein>
 <202006031845.F587F85A@keescook>
 <20200604125226.eztfrpvvuji7cbb2@wittgenstein>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20200604125226.eztfrpvvuji7cbb2@wittgenstein>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: 'Christian Brauner' <christian.brauner@ubuntu.com>, Kees Cook <keescook@chromium.org>
Cc: Sargun Dhillon <sargun@sargun.me>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Tycho Andersen <tycho@tycho.ws>, Matt Denton <mpdenton@google.com>, Jann Horn <jannh@google.com>, Chris Palmer <palmer@google.com>, Aleksa Sarai <cyphar@cyphar.com>, Robert Sesek <rsesek@google.com>, "containers@lists.linux-foundation.org" <containers@lists.linux-foundation.org>, Giuseppe Scrivano <gscrivan@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Daniel Wagner <daniel.wagner@bmw-carit.de>, "David S . Miller" <davem@davemloft.net>, John Fastabend <john.r.fastabend@intel.com>, Tejun Heo <tj@kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "cgroups@vger.kernel.org" <cgroups@vger.kern>

RnJvbTogQ2hyaXN0aWFuIEJyYXVuZXINCj4gU2VudDogMDQgSnVuZSAyMDIwIDEzOjUyDQouLg0K
PiBGb3Igc2NtIHlvdSBjYW4gZmFpbCBzb21ld2hlcmUgaW4gdGhlIG1pZGRsZSBvZiBwdXR0aW5n
IGFueSBudW1iZXIgb2YNCj4gZmlsZSBkZXNjcmlwdG9ycyBzbyB5b3UncmUgbGVmdCBpbiBhIHN0
YXRlIHdpdGggb25seSBhIHN1YnNldCBvZg0KPiByZXF1ZXN0ZWQgZmlsZSBkZXNjcmlwdG9ycyBp
bnN0YWxsZWQgc28gaXQncyBub3QgcmVhbGx5IHVzZWZ1bCB0aGVyZS4NCj4gQW5kIGlmIHlvdSBt
YW5hZ2UgdG8gaW5zdGFsbCBhbiBmZCBidXQgdGhlbiBmYWlsIHRvIHB1dF91c2VyKCkgaXQNCj4g
dXNlcnNwYWNlIGNhbiBzaW1wbHkgY2hlY2sgaXQncyBmZHMgdmlhIHByb2MgYW5kIGhhcyB0byBh
bnl3YXkgb24gYW55DQo+IHNjbSBtZXNzYWdlIGVycm9yLiBJZiB5b3UgZmFpbCBhbiBzY20gbWVz
c2FnZSB1c2Vyc3BhY2UgYmV0dGVyIGNoZWNrDQo+IHRoZWlyIGZkcy4NCg0KVGhlcmUgaXMgYSBz
aW1pbGFyIGVycm9yIHBhdGggaW4gdGhlIHNjdHAgJ3BlZWxvZmYnIGNvZGUuDQpJZiB0aGUgcHV0
X3VzZXIoKSBmYWlscyBpdCBjdXJyZW50bHkgY2xvc2VzIHRoZSBmZCBiZWZvcmUNCnJldHVybmlu
ZyAtRUZBVUxULg0KDQpJJ20gbm90IGF0IGFsbCBzdXJlIHRoaXMgaXMgaGVscGZ1bC4NClRoZSBh
cHBsaWNhdGlvbiBjYW4ndCB0ZWxsIHdoZXRoZXIgdGhlIFNJR1NFR1YgaGFwcGVuZWQgb24gdGhl
DQpjb3B5aW4gb2YgdGhlIHBhcmFtZXRlcnMgb3IgdGhlIGNvcHlvdXQgb2YgdGhlIHJlc3VsdC4N
Cg0KSVNUTSB0aGF0IGlmIHRoZSBhcHBsaWNhdGlvbiBwYXNzZXMgYW4gYWRkcmVzcyB0aGF0IGNh
bm5vdA0KYmUgd3JpdHRlbiB0byBpdCBkZXNlcnZlcyB3aGF0IGl0IGdldHMgLSB0eXBpY2FsbHkg
YW4gZmQgaXQNCmRvZXNuJ3Qga25vdyB0aGUgbnVtYmVyIG9mLg0KDQpXaGF0IGlzIGltcG9ydGFu
dCBpcyB0aGF0IHRoZSBrZXJuZWwgZGF0YSBpcyBjb25zaXN0ZW50Lg0KU28gd2hlbiB0aGUgcHJv
Y2VzcyBleGl0cyB0aGUgZmQgaXMgY2xvc2VkIGFuZCBhbGwgdGhlIHJlc291cmNlcw0KYXJlIHJl
bGVhc2VkLg0KDQoJRGF2aWQNCg0KLQ0KUmVnaXN0ZXJlZCBBZGRyZXNzIExha2VzaWRlLCBCcmFt
bGV5IFJvYWQsIE1vdW50IEZhcm0sIE1pbHRvbiBLZXluZXMsIE1LMSAxUFQsIFVLDQpSZWdpc3Ry
YXRpb24gTm86IDEzOTczODYgKFdhbGVzKQ0K

