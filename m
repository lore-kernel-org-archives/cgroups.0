From: Paul Moore <paul@paul-moore.com>
Subject: Re: [PATCH] security: selinux: allow per-file labeling for cgroupfs
Date: Tue, 22 Aug 2017 15:47:33 -0400
Message-ID: <CAHC9VhRiTnsPNoPZNi2aAQfN4va3Kg81QZgxoed6S-8iAFFvPA@mail.gmail.com>
References: <20170209155823.22148-1-runcom@redhat.com> <CAHC9VhSL3ZS3R2r39+qzYmvU1=8-jC2nzqkXNQ0Yk3+okKd7jw@mail.gmail.com>
 <1489177036.6824.57.camel@tycho.nsa.gov> <CAHC9VhSL1dm9b7ZohYyCU0PjKbbtYLe7XX7Xv3CsQQx4CtG_Fw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=sO1Y0vSpSdGRc5phWUzUegJA0TKUUs0QztbzhjSszxE=;
        b=o2KRpoJlrrAFOXr9I+aORg+KdLW0MDWo1lk7BRshYdN4e8y1C8Xw71cKspItBB8kC/
         fYJVminJtdXHkOOFkzwf3iVjJFyvCEBer6GAzHdfxN6eN84IZtNZIBu3vwH8YkVfboMz
         7buEzvlJYmJy+glxAILVSi4s1rWCLLxovSd5D5189u98Wif53EKZHf8AB5YuXngrxE6q
         6kinjy1Hq37C3VALxdbsyueBbE9NqyHL7cXV1wBh6AY8Lp0r+4kqVAkC4FBMPykIl3pM
         FEW0bg4IppkDXo7FE9VgYC2VPEZMt3GSbp+MyP9jbQAmqi5T4qanQP/eM5SjEYALhbNz
         ReJA==
In-Reply-To: <CAHC9VhSL1dm9b7ZohYyCU0PjKbbtYLe7XX7Xv3CsQQx4CtG_Fw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Stephen Smalley <sds@tycho.nsa.gov>, Antonio Murdaca <amurdaca@redhat.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov, vgoyal@redhat.com

On Fri, Mar 10, 2017 at 3:21 PM, Paul Moore <paul@paul-moore.com> wrote:
> On Fri, Mar 10, 2017 at 3:17 PM, Stephen Smalley <sds@tycho.nsa.gov> wrote:
>> On Fri, 2017-03-10 at 15:01 -0500, Paul Moore wrote:
>>> On Thu, Feb 9, 2017 at 10:58 AM, Antonio Murdaca <amurdaca@redhat.com
>>> > wrote:
>>> >
>>> > This patch allows genfscon per-file labeling for cgroupfs. For
>>> > instance,
>>> > this allows to label the "release_agent" file within each
>>> > cgroup mount and limit writes to it.
>>> >
>>> > Signed-off-by: Antonio Murdaca <runcom@redhat.com>
>>> > ---
>>> >  security/selinux/hooks.c | 2 ++
>>> >  1 file changed, 2 insertions(+)
>>>
>>> Now that the merge window is behind us, let's get this merged, but
>>> could you update it to use the selinux_policycap_cgroupseclabel
>>> policy
>>> capability?  See 2651225b5ebcdde ("selinux: wrap cgroup seclabel
>>> support with its own policy capability") for more information.
>>
>> I don't think that is necessary.  This change unlike the other one
>> should not yield any difference in behavior with existing policy; it
>> just allows one to specify fine-grained labeling for cgroup nodes in
>> future policy.  It doesn't affect any userspace interface.
>
> Yes, I thought about that, and if the policy capability was already
> present in a released kernel then I wouldn't worry about it much, but
> since the policy capability still only lives in the v4.11-rcX kernels
> I'd prefer to see this code wrapped with the policy capability ...
> even if all it really does is give me that warm fuzzy feeling.

FWIW, I just decided I didn't care that much about the policy
capability restriction for this patch and went ahead and merged it
into selinux/next.

-- 
paul moore
www.paul-moore.com
