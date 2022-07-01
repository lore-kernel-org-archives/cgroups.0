From: Lin Feng <linf-VqLewplIU37QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cgroup-v1: use find granularity format identifiers to
 make /proc/cgroups show pretty
Date: Fri, 1 Jul 2022 09:49:46 +0800
Message-ID: <5a6df5c4-e24d-1171-87a8-b013f861f0d5@wangsu.com>
References: <20220630082539.83602-1-linf@wangsu.com>
 <Yr5JVHhSUCrbT8OH@mtj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
In-Reply-To: <Yr5JVHhSUCrbT8OH-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Tejun,

On 7/1/22 09:09, Tejun Heo wrote:
> On Thu, Jun 30, 2022 at 04:25:39PM +0800, Lin Feng wrote:
>> The listing subsys info is unaligned with the header columns and we can
>> make the output more intuitive to read by specifying "left alignment"
>> and "fixed length" format styles for seq_printf.
> This has been proposed before but the file is useful only in cgroup1
> which is in maintenance mode and the format has been like that since
> forever. Given that there's some chance that it can break dumb
> parsers, the choice has been to leave it alone. It's such a dumb file
> format to begin with and just leaving it to wither and die seems to be
> the right direction.

Thanks for your explanation and sorry that I missed we have such a consensus
before.

I had considered that if this change would break the parsers, but it's likely
that it won't else the parser is really a broken one and needs some improvements.
On the other hand, cgroup-v1 still has many old users and kernel still has to
maintain it for some time for back compatible reason, so I think this tiny fix
should not be a bad idea.

Thanks,
linfeng

