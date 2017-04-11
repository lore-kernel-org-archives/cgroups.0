From: Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>
Subject: Re: [PATCH 15/19] kernel: convert audit_tree.count from atomic_t to refcount_t
Date: Tue, 11 Apr 2017 15:01:18 -0400
Message-ID: <CAHC9VhQUKFRcXAF=fdb5YByb=5L+rwEwwAExVLoc3zXFgAOTjQ@mail.gmail.com>
References: <1487585948-6401-1-git-send-email-elena.reshetova@intel.com>
 <1487585948-6401-16-git-send-email-elena.reshetova@intel.com>
 <CAHC9VhQW7xFHBLNQOQRKMftStu_aHjbUmp96VJrcfWzxuzE_kw@mail.gmail.com>
 <2236FBA76BA1254E88B949DDB74E612B41C4DE27@IRSMSX102.ger.corp.intel.com> <CAHC9VhQBB9srK85meAi41pxD0Vse3NiX1-zmKGXcoYh0vB_=9A@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=j12RAsJDQsg1BGIT3+jRhGT+dkwXrTifWlLbzcDS1kM=;
        b=PqRRYc8Dof19aZpe1ynyWv3J9SVn4ZbCqf5kuDPXZP+y6q22xgxrrMjJ7mzQVaVjdf
         3dCMPZP+trYb5STX3fFrOLrqzSHvEFT7L9KHIjmw28k76OrZQxxFu4pa5B0s26zgZlrV
         y5xcK6YzkZnMIp6yq6bFiLMUY8Xukzrx85qkblt3qgAJTDRqoF3axKpfredtwzdAaKqd
         cGaq1eBbif9EENMzuPLfzoCknBaCtlwAScbgnptk04V8NoIf9Ph+KSACEVP75AA/SrlR
         yp10Wq/GS/0DQ6p0fofA/TEM3ZLKQsaQGPe6CLIFIdZYgrlTCYT1P6uAO9YsSDpWAMfx
         I/iw==
In-Reply-To: <CAHC9VhQBB9srK85meAi41pxD0Vse3NiX1-zmKGXcoYh0vB_=9A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Reshetova, Elena" <elena.reshetova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-audit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <linux-audit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org" <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org" <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org" <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, "tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org" <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, "lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org" <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "alexander.shishkin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org" <alexander.shishkin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Eric Paris <eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org" <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "arnd-r2nGTMty4D4@public.gmane.org" <>

On Tue, Feb 28, 2017 at 5:11 PM, Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org> wrote:
> On Tue, Feb 21, 2017 at 2:15 AM, Reshetova, Elena
> <elena.reshetova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>>> On Mon, Feb 20, 2017 at 5:19 AM, Elena Reshetova
>>> <elena.reshetova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>>> > refcount_t type and corresponding API should be
>>> > used instead of atomic_t when the variable is used as
>>> > a reference counter. This allows to avoid accidental
>>> > refcounter overflows that might lead to use-after-free
>>> > situations.
>>> >
>>> > Signed-off-by: Elena Reshetova <elena.reshetova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>>> > Signed-off-by: Hans Liljestrand <ishkamiel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>> > Signed-off-by: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
>>> > Signed-off-by: David Windsor <dwindsor-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
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

Quick update on this: I needed to rebase the audit/next branch for
other reasons so I've gone ahead and merged 15/19 and 16/19 into
audit/next; they should go to Linus during the next merge window.
Thanks for your patience.

-- 
paul moore
www.paul-moore.com
