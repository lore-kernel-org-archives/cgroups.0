From: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cgroup: Refactor two assignments in
 css_task_iter_next_css_set()
Date: Mon, 15 Jun 2020 09:11:27 +0800
Message-ID: <4d6a3864-b4b4-9b32-1349-c40b11e28a8f@huawei.com>
References: <1592158208.5303.27.camel@HansenPartnership.com>
 <20200614232224.1804-1-zzuedu2000@163.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200614232224.1804-1-zzuedu2000-9Onoh4P/yGk@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: zzuedu2000-9Onoh4P/yGk@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Markus.Elfring-S0/GAf8tV78@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, buddy.zhang-Dw/NWeUnuQfQT0dZR+AlfA@public.gmane.org

On 2020/6/15 7:22, zzuedu2000-9Onoh4P/yGk@public.gmane.org wrote:
> On Sun, 2020-06-14 at 18:10 +0800, James.Bottomley@xxxxxxx wrote:
> 
>> it's arguable that having two statements instead of one makes the code
>> marginally more readable.
> 
> Above the function there is a similar line of code:
> l = it->tcset_pos->next;
> One line of code makes the code style consistent and more readable
> 

It would be much better if you are fixing a bug or developing a new feature
and while at it you do this cleanup conveniently, but this patch alone has
little value. 
