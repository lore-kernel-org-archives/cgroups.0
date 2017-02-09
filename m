From: Paul Moore <paul@paul-moore.com>
Subject: Re: [PATCH] security: selinux: allow per-file labeling for cgroupfs
Date: Thu, 9 Feb 2017 14:23:13 -0500
Message-ID: <CAHC9VhSj4ztDZwxfcuugaD5-OJrBVaJ=TQS=t4=jfL0+ZdbdYQ@mail.gmail.com>
References: <20170209160242.23405-1-amurdaca@redhat.com> <CAHC9VhRFxDuRJHYEuRs7kc4ivgaT=-SxdU-o5Lq7H-O+5JJRxQ@mail.gmail.com>
 <CALKLTGTc7U7ohxd44MHOuzVomW-oUsumqUqr0MKaUohw1NpSsg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=4tT33RfWgbKJOPAo+i1QBaFzbHkE1jNnWqMp7OUzIm8=;
        b=hVabpQ99Jl0ZULMTmkVftdeJ91v1eW/53UC6UDLdVHxTzKbXajwGWkXY6F3i9Cf844
         OMfwbNyTRn6RHivz2DPsJ6Vah9YhK43cXgNhncfONCy4+wzjXRFfPs7SSae6UjsMFPzU
         qwSj5eMnMQVl+Q2UmbdlcUB+p65bIPC51AOxtffQLE240ZbtPZM/QYyjsvC/FVK6qTxh
         2dYXtId7GwjoOoD8z3qpisWudtykYKh30ziMQoiuBWwKQYvQbFpXLl38h5hSaWK99wlf
         Hz3mAoXWyzQTZ1RFJu7UyKvyJcv7kV2i+OglGQAy8PplTeS/K/tbFo8ByEGNQZ18nl03
         2oiA==
In-Reply-To: <CALKLTGTc7U7ohxd44MHOuzVomW-oUsumqUqr0MKaUohw1NpSsg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Antonio Murdaca <amurdaca@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Antonio Murdaca <runcom@redhat.com>, selinux@tycho.nsa.gov, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

On Thu, Feb 9, 2017 at 12:39 PM, Antonio Murdaca <amurdaca@redhat.com> wrote:
> On Feb 9, 2017 17:14, "Paul Moore" <paul@paul-moore.com> wrote:
> On Thu, Feb 9, 2017 at 11:02 AM, Antonio Murdaca <amurdaca@redhat.com>
> wrote:
>> From: Antonio Murdaca <runcom@redhat.com>
>>
>> This patch allows genfscon per-file labeling for cgroupfs. For instance,
>> this allows to label the "release_agent" file within each
>> cgroup mount and limit writes to it.
>>
>> Signed-off-by: Antonio Murdaca <amurdaca@redhat.com>
>> ---
>>  security/selinux/hooks.c | 2 ++
>>  1 file changed, 2 insertions(+)
>
> This was already merged ... ?
>
>
> This is adding cgroup and cgroup2 to the other whitelist (afaict).

Yes, my apologies, I read this patch too quickly and confused it with
the previous cgroups patch.

Just to set expectations, this patch is too late for the upcoming
merge window, we can consider it in a few weeks once the merge window
has closed.  This should give you some time to do some further testing
(hint, hint).

-- 
paul moore
www.paul-moore.com
