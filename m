From: Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: Re: [PATCH v2 09/11] docs: Fix some broken references
Date: Wed, 16 May 2018 09:12:56 -0600
Message-ID: <CANLsYkwXUGJ-DM4M48SXuy+31r6sC7_Q3fc9Rgue6wFdeMQv6g@mail.gmail.com>
References: <cover.1525870886.git.mchehab+samsung@kernel.org>
 <e959f23d6f6905ee606fadfda13e2bb37deed017.1525870886.git.mchehab+samsung@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <xen-devel-bounces@lists.xenproject.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=mime-version:in-reply-to:references:from:date:message-id:subject:to
 :cc; bh=TFUWJ4JVXNBXG1/TG/4GxDmHGl4a+b7GMnf7cCN1wZQ=;
 b=X8CYXYNuQ3YwIpVeB1btlvP9DmazitAp3ks/dhg4FIWg/PpWDGoWmnWeEnOlNNuq9T
 RjXChl8qck2+pvIKf3oGKC68WF9eksxfehwEmeYKorhkAXl/tkT1MPuJYHgDGteC2DSz
 uwNL7rOwkZVP8urv8s1PeN6j8OTsMcFWU+7Fk=
In-Reply-To: <e959f23d6f6905ee606fadfda13e2bb37deed017.1525870886.git.mchehab+samsung@kernel.org>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.xenproject.org/mailman/options/xen-devel>,
 <mailto:xen-devel-request@lists.xenproject.org?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xenproject.org>
List-Help: <mailto:xen-devel-request@lists.xenproject.org?subject=help>
List-Subscribe: <https://lists.xenproject.org/mailman/listinfo/xen-devel>,
 <mailto:xen-devel-request@lists.xenproject.org?subject=subscribe>
Errors-To: xen-devel-bounces@lists.xenproject.org
Sender: "Xen-devel" <xen-devel-bounces@lists.xenproject.org>
Content-Type: text/plain; charset="us-ascii"
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Linus Walleij <linus.walleij@linaro.org>, Will Deacon <will.deacon@arm.com>, dri-devel@lists.freedesktop.org, Jaroslav Kysela <perex@perex.cz>, Eric Paris <eparis@parisplace.org>, linux-clk@vger.kernel.org, James Morris <jmorris@namei.org>, Alan Stern <stern@rowland.harvard.edu>, xen-devel@lists.xenproject.org, Boqun Feng <boqun.feng@gmail.com>, Nicholas Piggin <npiggin@gmail.com>, Sean Paul <seanpaul@chromium.org>, Thomas Gleixner <tglx@linutronix.de>, Antoine Jacquet <royale@zerezo.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Li Zefan <lizefan@huawei.com>, linux-crypto@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>, alsa-devel@alsa-project.org, Linux Doc Mailing List <linux-doc@vger.kernel.org>, David Airlie <airlied@linux.ie>

T24gOSBNYXkgMjAxOCBhdCAwNzoxOCwgTWF1cm8gQ2FydmFsaG8gQ2hlaGFiCjxtY2hlaGFiK3Nh
bXN1bmdAa2VybmVsLm9yZz4gd3JvdGU6Cj4gQXMgd2UgbW92ZSBzdHVmZiBhcm91bmQsIHNvbWUg
ZG9jIHJlZmVyZW5jZXMgYXJlIGJyb2tlbi4gRml4IHNvbWUgb2YKPiB0aGVtIHZpYSB0aGlzIHNj
cmlwdDoKPiAgICAgICAgIC4vc2NyaXB0cy9kb2N1bWVudGF0aW9uLWZpbGUtcmVmLWNoZWNrIC0t
Zml4LXJzdAo+Cj4gTWFudWFsbHkgY2hlY2tlZCBpZiB0aGUgcHJvZHVjZWQgcmVzdWx0IGlzIHZh
bGlkLCByZW1vdmluZyBhIGZldwo+IGZhbHNlLXBvc2l0aXZlcy4KPgo+IFNpZ25lZC1vZmYtYnk6
IE1hdXJvIENhcnZhbGhvIENoZWhhYiA8bWNoZWhhYitzYW1zdW5nQGtlcm5lbC5vcmc+Cj4gLS0t
Cgo+Cj4gZGlmZiAtLWdpdCBhL0RvY3VtZW50YXRpb24vdHJhY2UvY29yZXNpZ2h0LnR4dCBiL0Rv
Y3VtZW50YXRpb24vdHJhY2UvY29yZXNpZ2h0LnR4dAo+IGluZGV4IDFkNzRhZDAyMDJiNi4uZWZi
YzgzMjE0NmU3IDEwMDY0NAo+IC0tLSBhL0RvY3VtZW50YXRpb24vdHJhY2UvY29yZXNpZ2h0LnR4
dAo+ICsrKyBiL0RvY3VtZW50YXRpb24vdHJhY2UvY29yZXNpZ2h0LnR4dAo+IEBAIC00MjYsNSAr
NDI2LDUgQEAgcm9vdEBnZW5lcmljYXJtdjg6fiMKPiAgRGV0YWlscyBvbiBob3cgdG8gdXNlIHRo
ZSBnZW5lcmljIFNUTSBBUEkgY2FuIGJlIGZvdW5kIGhlcmUgWzJdLgo+Cj4gIFsxXS4gRG9jdW1l
bnRhdGlvbi9BQkkvdGVzdGluZy9zeXNmcy1idXMtY29yZXNpZ2h0LWRldmljZXMtc3RtCj4gLVsy
XS4gRG9jdW1lbnRhdGlvbi90cmFjZS9zdG0udHh0Cj4gK1syXS4gRG9jdW1lbnRhdGlvbi90cmFj
ZS9zdG0ucnN0Cj4gIFszXS4gaHR0cHM6Ly9naXRodWIuY29tL0xpbmFyby9wZXJmLW9wZW5jc2QK
CkFja2VkLWJ5OiBNYXRoaWV1IFBvaXJpZXIgPG1hdGhpZXUucG9pcmllckBsaW5hcm8ub3JnPgoK
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KWGVuLWRldmVs
IG1haWxpbmcgbGlzdApYZW4tZGV2ZWxAbGlzdHMueGVucHJvamVjdC5vcmcKaHR0cHM6Ly9saXN0
cy54ZW5wcm9qZWN0Lm9yZy9tYWlsbWFuL2xpc3RpbmZvL3hlbi1kZXZlbA==
