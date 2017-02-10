From: Daniel J Walsh <dwalsh-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] security: selinux: allow per-file labeling for cgroupfs
Date: Fri, 10 Feb 2017 18:05:55 -0500
Message-ID: <4835d22f-2ec2-0dd8-39a3-562335682568@redhat.com>
References: <20170209160242.23405-1-amurdaca@redhat.com>
 <CAHC9VhRFxDuRJHYEuRs7kc4ivgaT=-SxdU-o5Lq7H-O+5JJRxQ@mail.gmail.com>
 <CALKLTGTc7U7ohxd44MHOuzVomW-oUsumqUqr0MKaUohw1NpSsg@mail.gmail.com>
 <CAHC9VhSj4ztDZwxfcuugaD5-OJrBVaJ=TQS=t4=jfL0+ZdbdYQ@mail.gmail.com>
 <CALKLTGTjpBYd5-M9RiO-Q4H_SokEiPJYptbxktg_aPccws59Jw@mail.gmail.com>
 <CAHC9VhTMxN5sqk+BL6f4-V7o3ez=7fMHBWFRAvj+j5iD+VkiMA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAHC9VhTMxN5sqk+BL6f4-V7o3ez=7fMHBWFRAvj+j5iD+VkiMA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>, Antonio Murdaca <amurdaca-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Antonio Murdaca <runcom-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>



On 02/09/2017 06:04 PM, Paul Moore wrote:
> On Thu, Feb 9, 2017 at 5:32 PM, Antonio Murdaca <amurdaca-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>>
>> On Feb 9, 2017 20:23, "Paul Moore" <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org> wrote:
>>
>> On Thu, Feb 9, 2017 at 12:39 PM, Antonio Murdaca <amurdaca-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> wrote:
>>> On Feb 9, 2017 17:14, "Paul Moore" <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org> wrote:
>>> On Thu, Feb 9, 2017 at 11:02 AM, Antonio Murdaca <amurdaca-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>> wrote:
>>>> From: Antonio Murdaca <runcom-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>>>
>>>> This patch allows genfscon per-file labeling for cgroupfs. For instance,
>>>> this allows to label the "release_agent" file within each
>>>> cgroup mount and limit writes to it.
>>>>
>>>> Signed-off-by: Antonio Murdaca <amurdaca-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>>> ---
>>>>  security/selinux/hooks.c | 2 ++
>>>>  1 file changed, 2 insertions(+)
>>> This was already merged ... ?
>>>
>>>
>>> This is adding cgroup and cgroup2 to the other whitelist (afaict).
>> Yes, my apologies, I read this patch too quickly and confused it with
>> the previous cgroups patch.
>>
>> Just to set expectations, this patch is too late for the upcoming
>> merge window, we can consider it in a few weeks once the merge window
>> has closed.  This should give you some time to do some further testing
>> (hint, hint).
>>
>>
>> Sure, I'm going to test this and add tests in selinux-testsuite as well
> Great, thank you.
>
No problem on waiting for this patch.  Stephen asked for this, but this is
not something we are currently planning on using with containers.
