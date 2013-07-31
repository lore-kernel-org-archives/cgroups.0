From: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/4] memcg: fix memcg resource limit overflow issues
Date: Wed, 31 Jul 2013 18:04:30 +0800
Message-ID: <CAFj3OHWOKn3NdbBzhKq5iCoB8BaiZVuf=VauLuB=NthyuDgZdQ@mail.gmail.com>
References: <1375255885-10648-1-git-send-email-h.huangqiang@huawei.com>
	<CAFj3OHX4WLaecyE_zFbnFKs9wrCWTq2eDAUDMxqPg8=TYt18gg@mail.gmail.com>
	<51F8D016.4090009@huawei.com>
	<51F8D0E1.4010007@huawei.com>
	<CAFj3OHUEVM+BtoYS8wbXRU42Q8_=1X5qaQm7QY8oBc=ONAdfOA@mail.gmail.com>
	<20130731095010.GA5012@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=A2jS5EB8kb2Jyo6hQtEfxlS5Z7+5FIC2lKEMFxmd3Nk=;
        b=tdgpn7jKFtF5y4Ff5WJEZg0V9rcTCMpif7IprQQCyIQ0MERUGhyFP7s9htZnIADsQ+
         ZWrDtyGtsWLtodzuhQ7DQVs0LDG0eL1JuTfvtpmK/qwX/hSGp929FacTdkCU99lPuCKM
         Pyqzpv1GHsN9o/Try/ZQ1/x4yHUL8OQ/U17WcPtDxRZXrFATuIJ6Mz7+qr1lu74gmYy9
         nixN5q5q9xruWiTjcTgskVMbR//o6hcnZf42eeK9+oVkE+XPH0JT/b8dxN357IKruWKc
         iv8ZXKKKeqAs6CbLcHlnBVHju/O9fCwodNWIbnQPT0JvKYQ6c9Q0ugUj0g2kGN/DU66K
         i4zQ==
In-Reply-To: <20130731095010.GA5012-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Qiang Huang <h.huangqiang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>, Daisuke Nishimura <nishimura-YQH0OdQVrdy45+QrQBaojngSJqDPrsil@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Jeff Liu <jeff.liu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

On Wed, Jul 31, 2013 at 5:50 PM, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org> wrote:
> On Wed 31-07-13 17:39:43, Sha Zhengju wrote:
>> I don't want to block the community, since they're urgent to the
>> patches and Michal has already reviewed them just now, I won't be
>> so caustic on it. I'm OK of letting the codes in under the rules of
>> community.
>
> Your s-o-b has been preserved which was sufficient for me, but
> preserving the original From would be polity and sorry I have missed
> that, I would have screamed as well. It should be added in the next
> repost.

Thanks for the support.

> Qiang Huang s-o-b is appropriate as well as he has rebased and reposted
> the series, though.
>
> Anyway, I do not see any reason to postpone this series as it is a good
> improvement.
>

Yeah, I thought the problem it tries to solve is rarely encountered
when I sent it last time. But now I also glad to see it merged soon.



Thanks,
Sha
