From: Antonio Murdaca <amurdaca-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] security: selinux: allow changing labels for cgroupfs
Date: Thu, 2 Feb 2017 16:35:29 +0100
Message-ID: <CALKLTGQYsxJ2My9r-4f8taGRxK0P7L5CDL6DcfdvKC1t_nQkuQ@mail.gmail.com>
References: <20170202144228.24454-1-runcom@redhat.com> <20170202150118.GA6441@localhost.localdomain>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170202150118.GA6441-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org, Antonio Murdaca <amurdaca-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Thu, Feb 2, 2017 at 4:01 PM, Gary Tierney <gary.tierney-KK0ffGbhmjU@public.gmane.org> wrote:
> On Thu, Feb 02, 2017 at 03:42:28PM +0100, Antonio Murdaca wrote:
>> This patch allows changing labels for cgroup mounts. Previously, running
>> chcon on cgroupfs would throw an "Operation not supported". This patch
>> specifically whitelist cgroupfs.
>>
>> The patch could also allow containers to write only to the systemd cgroup
>> for instance, while the other cgroups are kept with cgroup_t label.
>>
>> Signed-off-by: Antonio Murdaca <runcom-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> ---
>>  security/selinux/hooks.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
>> index 3b955c6..4e84211 100644
>> --- a/security/selinux/hooks.c
>> +++ b/security/selinux/hooks.c
>> @@ -480,6 +480,7 @@ static int selinux_is_sblabel_mnt(struct super_block *sb)
>>               sbsec->behavior == SECURITY_FS_USE_NATIVE ||
>>               /* Special handling. Genfs but also in-core setxattr handler */
>>               !strcmp(sb->s_type->name, "sysfs") ||
>> +             !strcmp(sb->s_type->name, "cgroup") ||
>
> Should we also include "cgroup2" here, since they are defined as 2
> distinct filesystems? https://github.com/SELinuxProject/selinux-kernel/blob/master/kernel/cgroup.c#L2314-L2326

likely yes

>
>>               !strcmp(sb->s_type->name, "pstore") ||
>>               !strcmp(sb->s_type->name, "debugfs") ||
>>               !strcmp(sb->s_type->name, "tracefs") ||
>> --
>> 2.9.3
>>
>> _______________________________________________
>> Selinux mailing list
>> Selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org
>> To unsubscribe, send email to Selinux-leave-+05T5uksL2pAGbPMOrvdOA@public.gmane.org
>> To get help, send an email containing "help" to Selinux-request-+05T5uksL2pAGbPMOrvdOA@public.gmane.org



-- 
Antonio (runcom) Murdaca, RHCE
Senior Software Engineer - Containers
09B9 8F09 3E2D C310 E250 69B5 B2BE AD15 0DE9 36B9
