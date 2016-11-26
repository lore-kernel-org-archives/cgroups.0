From: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cpuset: Remove unused 'struct cpuset*' variable
Date: Sat, 26 Nov 2016 08:42:40 +0800
Message-ID: <5838DA80.6040208@huawei.com>
References: <kirtika@chromium.org>
 <1480049712-17224-1-git-send-email-kirtika@chromium.org>
 <5837D01C.1070803@huawei.com> <4410043.lxDXIbV3iK@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4410043.lxDXIbV3iK@wuerfel>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: Kirtika Ruchandani <kirtika-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2016/11/25 17:46, Arnd Bergmann wrote:
> On Friday, November 25, 2016 1:46:04 PM CET Zefan Li wrote:
>> On 2016/11/25 12:55, Kirtika Ruchandani wrote:
>>> 'struct cpuset* cs' that is set but not used, was introduced in commit
>>> 1f7dd3e5a6e4 ("cgroup: fix handling of multi-destination migration from subtree_control enabling").
>>> cpuset_cancel_attach() uses css_cs(css) instead. Compiling with W=1
>>> gives the folllowing harmless warning, which we'd like to fix to
>>> reduce the noise with W=1 in the kernel.
>>>
>>> kernel/cpuset.c: In function ‘cpuset_cancel_attach’:
>>> kernel/cpuset.c:1502:17: warning: variable ‘cs’ set but not used [-Wunused-but-set-variable]
>>>   struct cpuset *cs;
>>>                  ^
>>>
>>> Fixes: 1f7dd3e5a6e4 ("cgroup: fix handling of multi-destination migration from subtree_control enabling").
>>
>> This isn't a bug, so I don't think this tag is proper.
> 
> I think it's ok since the changelog makes it clear that the
> warning is harmless. It's still useful information to know
> what commit introduced the warning, and the warning is fixed
> by this patch.
> 

People like stable tree maintainers use scripts to find out bug fixes
that needs to be backported to older kernels, and those scripts tracks
the Fixes tag. No doubt this patch doesn't require backporting, so
it's better avoid using this tag.
