From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V2] cgroup: Introduce cgroup_detach_task().
Date: Tue, 26 Aug 2014 09:35:36 +0800
Message-ID: <53FBE468.6050805@huawei.com>
References: <1408966330-2374-1-git-send-email-yangds.fnst@cn.fujitsu.com> <20140825141220.GA31066@mtj.dyndns.org> <CA+qeAOq7hYq-TJMh8jQpJy=nWwk2FsUMSS1Hd=-JkhLLXbweEQ@mail.gmail.com> <20140825144710.GA21688@htj.dyndns.org> <CA+qeAOpiW41i3dKyxYp_G9kB=Z9Kr7ZXeJOyq8QZP=qy6H6T3Q@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA+qeAOpiW41i3dKyxYp_G9kB=Z9Kr7ZXeJOyq8QZP=qy6H6T3Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Dongsheng Yang <dongsheng081251-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dongsheng Yang <yangds.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2014/8/25 23:00, Dongsheng Yang wrote:
> On Mon, Aug 25, 2014 at 10:47 PM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>> On Mon, Aug 25, 2014 at 10:46:03PM +0800, Dongsheng Yang wrote:
>>> My point here is that attaching and detaching are a pair of operations.
>>
>> There is no detaching from a cgroup.  A task is always attached to a
>> cgroup whether that's a root or non-root cgroup.
> 
> Okey, I should not think it as attaching and detaching. Just treat them as
> a move between root and non-root cgroup.
> 
> It sounds reasonable to me now.
> 

I from time to time have to explain this to other people.
