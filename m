From: Paul Moore <paul@paul-moore.com>
Subject: Re: [PATCH 15/19] kernel: convert audit_tree.count from atomic_t to
	refcount_t
Date: Tue, 28 Feb 2017 17:11:05 -0500
Message-ID: <CAHC9VhQBB9srK85meAi41pxD0Vse3NiX1-zmKGXcoYh0vB_=9A@mail.gmail.com>
References: <1487585948-6401-1-git-send-email-elena.reshetova@intel.com>
	<1487585948-6401-16-git-send-email-elena.reshetova@intel.com>
	<CAHC9VhQW7xFHBLNQOQRKMftStu_aHjbUmp96VJrcfWzxuzE_kw@mail.gmail.com>
	<2236FBA76BA1254E88B949DDB74E612B41C4DE27@IRSMSX102.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-audit-bounces@redhat.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
	h=mime-version:in-reply-to:references:from:date:message-id:subject:to
	:cc; bh=jXoa570F/8MxlKmf6EAF7aISRMikEUcMPUrH6yxNAuc=;
	b=Rui44qPRf2kuU8pWQ2cFJWymlKp1tTzwcy19Diu0Csvh/RONde69ApjgNwYC9Zmxku
	icglH2xJU3CrhaVGVR+xrj6Ck7E5t4bnKSCkSgp2C118AMGMDFfWzl6hbz66Sa5JHH/3
	U7U8AsEEog4J2wp1NAOn91wlaCgMWJADgTThnydd2q/tmoayXhV/NLfAavGty/yrXpbB
	48Itaq/4VuywcTqbn72ROqvadLyvZS+316SSBX/5cNGqtKX1a4VQGpmi7UgAjipvJEzJ
	Qf1KpEQcbvYmib0xhx3uD4NDOs8oltrtw0xxuXaxoDO1vn8qaBm74sFeR/LWWRUU2iUG
	osBg==
In-Reply-To: <2236FBA76BA1254E88B949DDB74E612B41C4DE27@IRSMSX102.ger.corp.intel.com>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/linux-audit>,
	<mailto:linux-audit-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/linux-audit>
List-Post: <mailto:linux-audit@redhat.com>
List-Help: <mailto:linux-audit-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/linux-audit>,
	<mailto:linux-audit-request@redhat.com?subject=subscribe>
Sender: linux-audit-bounces@redhat.com
Errors-To: linux-audit-bounces@redhat.com
To: "Reshetova, Elena" <elena.reshetova@intel.com>
Cc: "lizefan@huawei.com" <lizefan@huawei.com>, "arnd@arndb.de" <arnd@arndb.de>, "peterz@infradead.org" <peterz@infradead.org>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, Hans Liljestrand <ishkamiel@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "acme@kernel.org" <acme@kernel.org>, "tj@kernel.org" <tj@kernel.org>, "alexander.shishkin@linux.intel.com" <alexander.shishkin@linux.intel.com>, "linux-audit@redhat.com" <linux-audit@redhat.com>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "luto@kernel.org" <luto@kernel.org>, "hannes@cmpxchg.org" <hannes@cmpxchg.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>

On Tue, Feb 21, 2017 at 2:15 AM, Reshetova, Elena
<elena.reshetova@intel.com> wrote:
>> On Mon, Feb 20, 2017 at 5:19 AM, Elena Reshetova
>> <elena.reshetova@intel.com> wrote:
>> > refcount_t type and corresponding API should be
>> > used instead of atomic_t when the variable is used as
>> > a reference counter. This allows to avoid accidental
>> > refcounter overflows that might lead to use-after-free
>> > situations.
>> >
>> > Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
>> > Signed-off-by: Hans Liljestrand <ishkamiel@gmail.com>
>> > Signed-off-by: Kees Cook <keescook@chromium.org>
>> > Signed-off-by: David Windsor <dwindsor@gmail.com>
>> > ---
>> >  kernel/audit_tree.c | 8 ++++----
>> >  1 file changed, 4 insertions(+), 4 deletions(-)
>>
>> No objection on my end, same for patch 16/19.
>>
>> I have no problem merging both these patches into the audit/next
>> branch after the merge window, is that your goal or are you merging
>> these via a different tree?
>
> Thank you Paul! I think it is better if they go through the trees they supposed to go through
> since this way they would get more testing and etc. So, please take the relevant ones to your tree when the time is right.
>
> After the first round, I guess we will see what patches are not propagating and then maybe take them via Kees tree.

I just realized that include/linux/refcount.h didn't make it into
v4.10 which means there is going to be delay until I merge them into
the audit tree (I don't base the tree on -rc releases except under
extreme circumstances).  I've got the patches queued up in a private
holding branch (I added #includes BTW) so I won't forget, but as a
FYI, they likely won't make it in until v4.12.

-- 
paul moore
www.paul-moore.com
