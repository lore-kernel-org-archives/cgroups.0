From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC] splitting cgroup.c
Date: Thu, 19 Jan 2012 04:30:23 -0800
Message-ID: <CAOS58YMAQ0siUa=j8KsdWiAM3rqtZTvbOvmGc3L3cU0zwpuHPQ@mail.gmail.com>
References: <4F177C67.6070907@cn.fujitsu.com>
	<20120119022401.GH21533@google.com>
	<4F17C5A6.50501@cn.fujitsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        bh=gZVzLcjUo9taqQzoZgH2lgmZAckwqHsieL2QBD/nFtg=;
        b=w+4lZK+Iq5J1wVJviSl4AvoQk5hp2y/DPm86Nv3AS+B+B8Iof10K3pvjY9n7zITR8y
         3hbbEJcfb3870C3zk3OBVcfwU6N7UPBXA67pMC0q+J04/0LUUPzEVkFMlySUuRVkoIu+
         xo1RqhamBSnz1D9rKhLw7le7X6/G7idvpu2lg=
In-Reply-To: <4F17C5A6.50501-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello, Li.

On Wed, Jan 18, 2012 at 11:26 PM, Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org> wrote:
>> I agree that splitting is necessary but IMHO splitting usually tends
>> to go too far. =A0Maybe we can split it into two and think about fur=
ther
>> splitting later on? =A0e.g. internal logic vs. userland interfacing.
>
> This isn't feasible. The feasible way is to split by functionality,
> which I think was the way taken by perf developers.

Eh? Feasible or desirable?  How can it be not feasible?  Why?

Thanks.

--=20
tejun
