From: Dongsheng Yang <dongsheng081251-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V2] cgroup: Introduce cgroup_detach_task().
Date: Tue, 26 Aug 2014 10:15:47 +0800
Message-ID: <CA+qeAOq-=Yzi6tNq_-2O3yYamxXH99fTd=BUFSrbgcvxW5sRSA@mail.gmail.com>
References: <1408966330-2374-1-git-send-email-yangds.fnst@cn.fujitsu.com>
	<20140825141220.GA31066@mtj.dyndns.org>
	<CA+qeAOq7hYq-TJMh8jQpJy=nWwk2FsUMSS1Hd=-JkhLLXbweEQ@mail.gmail.com>
	<20140825144710.GA21688@htj.dyndns.org>
	<CA+qeAOpiW41i3dKyxYp_G9kB=Z9Kr7ZXeJOyq8QZP=qy6H6T3Q@mail.gmail.com>
	<53FBE468.6050805@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=AY49GRnugHdK5Y91HsjYKvSmbfNwwhyXQkc8l6FRNaA=;
        b=rHcJwHPK8EpiHltcV9AEJykONCLVNGOswIcpqn4pr+uYDfHenNflUATcewaJ8cpl53
         S9cEL2foG20TYEwzCnZ0vw3zcF3FGTLKi3/x1oDDLtt8Ygaq68tr9/V08dI+DvTgggTx
         /w3nlEGaHMXmnFT80wy9fF2Nni+Mq3uZwHWcW4jDsoFO50Sl9KKGfF9MJ8vVjwcxlYpl
         1ZSInpEN/Xc9+rNRIS1kYdQy7pTKRmyMiGY0b37zjsA3c0bWZaX1G6u2zuD6LtLQCd8q
         Ov8d3dB8KlIvwErRzrff0F8C8uCo4d0WE+THQZDY3fPflIJqhsBGSNPH0fsHZuLxU6Ao
         Jf2g==
In-Reply-To: <53FBE468.6050805-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dongsheng Yang <yangds.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Aug 26, 2014 at 9:35 AM, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:
> On 2014/8/25 23:00, Dongsheng Yang wrote:
>> On Mon, Aug 25, 2014 at 10:47 PM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>>> On Mon, Aug 25, 2014 at 10:46:03PM +0800, Dongsheng Yang wrote:
>>>> My point here is that attaching and detaching are a pair of operations.
>>>
>>> There is no detaching from a cgroup.  A task is always attached to a
>>> cgroup whether that's a root or non-root cgroup.
>>
>> Okey, I should not think it as attaching and detaching. Just treat them as
>> a move between root and non-root cgroup.
>>
>> It sounds reasonable to me now.
>>
>
> I from time to time have to explain this to other people.

Ha, we usually want to find a detach function when we saw a function
named as cgroup_attach_task().
>
