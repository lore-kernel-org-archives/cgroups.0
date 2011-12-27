From: Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Subject: Re: [PATCH] cgroup: move a check to parse_cgroupfs_options()
Date: Tue, 27 Dec 2011 09:48:57 +0800
Message-ID: <4EF92409.3090404@cn.fujitsu.com>
References: <4EF2EDA7.4010004@cn.fujitsu.com>	<20111222152011.GA17084@google.com>	<4EF3F834.0@cn.fujitsu.com> <CAOS58YMffJ4uH02H0TH_DmhtjQOVgz2_u_6HJqsGnR6PQ3ZGzw@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAOS58YMffJ4uH02H0TH_DmhtjQOVgz2_u_6HJqsGnR6PQ3ZGzw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Tejun Heo wrote:
> Hello,
> 
> On Thu, Dec 22, 2011 at 7:40 PM, Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org> wrote:
>>> And where did this one go?
>>
>> The other one I removed sets opts->new_root to NULL, and this one detects
>> the NULL ptr:
>>
>> if (!opts->subsys_bits && !opts->none)
>>        return NULL;
>> ...
>> opts->new_root = NULL;
>> ...
>> if (!opts->new_root)
>>        return -EINVAL;
>>
>> shortcut to:
>>
>> if (!opts->subsys_bits && !opts->none)
>>        return -EINVAL;
> 
> Thanks for the explanation. Maybe explaining it briefly in the commit
> message would be nice?
> 

I recalled why we have this check in this place, that is to allow mounting
by hierarchy name, but it has been broken for a long time. I'll send a
fix with detailed changelog.
