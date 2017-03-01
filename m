From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH 15/19] kernel: convert audit_tree.count from atomic_t to refcount_t
Date: Tue, 28 Feb 2017 16:16:41 -0800
Message-ID: <CAGXu5j+FdV--H8VBxJoZnY6ktgiyv4xSheQOkD77B-L-Cd1SVg@mail.gmail.com>
References: <1487585948-6401-1-git-send-email-elena.reshetova@intel.com>
 <1487585948-6401-16-git-send-email-elena.reshetova@intel.com>
 <CAHC9VhQW7xFHBLNQOQRKMftStu_aHjbUmp96VJrcfWzxuzE_kw@mail.gmail.com>
 <2236FBA76BA1254E88B949DDB74E612B41C4DE27@IRSMSX102.ger.corp.intel.com> <CAHC9VhQBB9srK85meAi41pxD0Vse3NiX1-zmKGXcoYh0vB_=9A@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:sender:in-reply-to:references:from:date:message-id
         :subject:to:cc;
        bh=kr5alZQ6qVozU26bmeGgarKpBu5cjaYzp+R0HWC6HPM=;
        b=frtlEykTLL3ZUUzkr4Jna/OUPQ3VxRqW6czBWpJ3+nBm8UxuHY8PYXLf39aWN1peH3
         e79q9JhdieGDWBdGI4lKIp9Pb5EHqlj3OHciWT8HZm8b0MHM1L6mjyhngmbU8JS9vXSs
         23wUmFhdHyt02ct8Em4GSdiH2aXFERyQUBYjHZncRNKlb35wLf4MpUcoJ8rPHgqUbd3S
         FSVO5Mh5+qfiDBBaabqoiYTR9Gabd0X5o30ahE1tNzuJWNLyKLCOnAoqD2ziXnqGgvo3
         XcizRd5guv7i0LAC9ChrpDeLP09AyPtaF6A6cn2wi/rPvIeYCnN2Ch2wdo8J2Bxg1sNk
         42dw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:sender:in-reply-to:references:from:date:message-id
         :subject:to:cc;
        bh=kr5alZQ6qVozU26bmeGgarKpBu5cjaYzp+R0HWC6HPM=;
        b=l9TfMR18qHGragZSjEaD7waV9/zk4bOYsY+RwNw1cbsPcud36aSn8vZyLlw1ErALI9
         5XstUbR05DpY5AL2drZBFMZIzSBVMOymc5j80dgLhmn9y1X6CJJfuViE0KqszBtK5dcy
         Oeenq1yb75M9qarVipBc8LZhmewrtfx83ZUo4=
In-Reply-To: <CAHC9VhQBB9srK85meAi41pxD0Vse3NiX1-zmKGXcoYh0vB_=9A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Paul Moore <paul@paul-moore.com>
Cc: "Reshetova, Elena" <elena.reshetova@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-audit@redhat.com" <linux-audit@redhat.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "peterz@infradead.org" <peterz@infradead.org>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "tj@kernel.org" <tj@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>, "hannes@cmpxchg.org" <hannes@cmpxchg.org>, "lizefan@huawei.com" <lizefan@huawei.com>, "acme@kernel.org" <acme@kernel.org>, "alexander.shishkin@linux.intel.com" <alexander.shishkin@linux.intel.com>, Eric Paris <eparis@redhat.com>, akpm@linux-foundation.org

On Tue, Feb 28, 2017 at 2:11 PM, Paul Moore <paul@paul-moore.com> wrote:
> On Tue, Feb 21, 2017 at 2:15 AM, Reshetova, Elena
> <elena.reshetova@intel.com> wrote:
>>> On Mon, Feb 20, 2017 at 5:19 AM, Elena Reshetova
>>> <elena.reshetova@intel.com> wrote:
>>> > refcount_t type and corresponding API should be
>>> > used instead of atomic_t when the variable is used as
>>> > a reference counter. This allows to avoid accidental
>>> > refcounter overflows that might lead to use-after-free
>>> > situations.
>>> >
>>> > Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
>>> > Signed-off-by: Hans Liljestrand <ishkamiel@gmail.com>
>>> > Signed-off-by: Kees Cook <keescook@chromium.org>
>>> > Signed-off-by: David Windsor <dwindsor@gmail.com>
>>> > ---
>>> >  kernel/audit_tree.c | 8 ++++----
>>> >  1 file changed, 4 insertions(+), 4 deletions(-)
>>>
>>> No objection on my end, same for patch 16/19.
>>>
>>> I have no problem merging both these patches into the audit/next
>>> branch after the merge window, is that your goal or are you merging
>>> these via a different tree?
>>
>> Thank you Paul! I think it is better if they go through the trees they supposed to go through
>> since this way they would get more testing and etc. So, please take the relevant ones to your tree when the time is right.
>>
>> After the first round, I guess we will see what patches are not propagating and then maybe take them via Kees tree.
>
> I just realized that include/linux/refcount.h didn't make it into
> v4.10 which means there is going to be delay until I merge them into
> the audit tree (I don't base the tree on -rc releases except under
> extreme circumstances).  I've got the patches queued up in a private
> holding branch (I added #includes BTW) so I won't forget, but as a
> FYI, they likely won't make it in until v4.12.

I'm not asking for you to change this, but I am curious: doesn't that
force you to always be a release behind? I've tended to base trees on
-rc2 (and then the final release while the next merge window is open).
But that may be because I tend to have such wide dependencies...

-Kees

-- 
Kees Cook
Pixel Security
