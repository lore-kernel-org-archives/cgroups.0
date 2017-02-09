From: Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>
Subject: Re: [PATCH] security: selinux: allow per-file labeling for cgroupfs
Date: Thu, 9 Feb 2017 18:04:57 -0500
Message-ID: <CAHC9VhTMxN5sqk+BL6f4-V7o3ez=7fMHBWFRAvj+j5iD+VkiMA@mail.gmail.com>
References: <20170209160242.23405-1-amurdaca@redhat.com>
 <CAHC9VhRFxDuRJHYEuRs7kc4ivgaT=-SxdU-o5Lq7H-O+5JJRxQ@mail.gmail.com>
 <CALKLTGTc7U7ohxd44MHOuzVomW-oUsumqUqr0MKaUohw1NpSsg@mail.gmail.com>
 <CAHC9VhSj4ztDZwxfcuugaD5-OJrBVaJ=TQS=t4=jfL0+ZdbdYQ@mail.gmail.com>
 <CALKLTGTjpBYd5-M9RiO-Q4H_SokEiPJYptbxktg_aPccws59Jw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <selinux-bounces-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
 h=mime-version:in-reply-to:references:from:date:message-id:subject:to
 :cc; bh=mtlJ6tOOiM0xOUIWSfGsr5C7j0T/qElGOGw0OcnqemI=;
 b=Pgc7mIVd8t6R29UrrsqsqKsLs2kXjsfZqSNqusEs5tsZJ81TJfcVOsccAqtX2QW/vc
 R1qVpwt3z6KwfzZqZq2sZq/hPwzVFhmPI2mRcqJfbv/4REA3HuZ5QyY5/vfXam6SV0IM
 yOSVL6wKrSMZmcvodplXJI7R8GXIEKHnizn15NbfNlTW6J7LQM9dqPbqmV4gsnTvnEGU
 LwZ7oHZuIlwvLDkqgeRndfLxhG2XP2GazS2bF+bJYyTcrYgmk8nG4LjzXyu8sKbupBl3
 m7kO+1RnanZya4YD9hvBFh4AKTLom+SutbS4nOWHmSFw7efYiAdEHbN+Adq1qNkxuCJ+
 12eQ==
In-Reply-To: <CALKLTGTjpBYd5-M9RiO-Q4H_SokEiPJYptbxktg_aPccws59Jw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>
List-Help: <mailto:selinux-request-+05T5uksL2qpZYMLLGbcSA@public.gmane.org?subject=help>
Errors-To: selinux-bounces-+05T5uksL2qpZYMLLGbcSA@public.gmane.org
Sender: "Selinux" <selinux-bounces-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>
To: Antonio Murdaca <amurdaca-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Antonio Murdaca <runcom-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Thu, Feb 9, 2017 at 5:32 PM, Antonio Murdaca <amurdaca-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
>
> On Feb 9, 2017 20:23, "Paul Moore" <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org> wrote:
>
> On Thu, Feb 9, 2017 at 12:39 PM, Antonio Murdaca <amurdaca-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> wrote:
>> On Feb 9, 2017 17:14, "Paul Moore" <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org> wrote:
>> On Thu, Feb 9, 2017 at 11:02 AM, Antonio Murdaca <amurdaca-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> wrote:
>>> From: Antonio Murdaca <runcom-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>>
>>> This patch allows genfscon per-file labeling for cgroupfs. For instance,
>>> this allows to label the "release_agent" file within each
>>> cgroup mount and limit writes to it.
>>>
>>> Signed-off-by: Antonio Murdaca <amurdaca-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>> ---
>>>  security/selinux/hooks.c | 2 ++
>>>  1 file changed, 2 insertions(+)
>>
>> This was already merged ... ?
>>
>>
>> This is adding cgroup and cgroup2 to the other whitelist (afaict).
>
> Yes, my apologies, I read this patch too quickly and confused it with
> the previous cgroups patch.
>
> Just to set expectations, this patch is too late for the upcoming
> merge window, we can consider it in a few weeks once the merge window
> has closed.  This should give you some time to do some further testing
> (hint, hint).
>
>
> Sure, I'm going to test this and add tests in selinux-testsuite as well

Great, thank you.

-- 
paul moore
www.paul-moore.com
_______________________________________________
Selinux mailing list
Selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org
To unsubscribe, send email to Selinux-leave-+05T5uksL2pAGbPMOrvdOA@public.gmane.org
To get help, send an email containing "help" to Selinux-request-+05T5uksL2pAGbPMOrvdOA@public.gmane.org
