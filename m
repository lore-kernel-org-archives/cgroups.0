From: Topi Miettinen <toiwoton-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC 02/18] cgroup_pids: track maximum pids
Date: Mon, 13 Jun 2016 21:59:32 +0000
Message-ID: <15ef1041-35b6-cb31-ff98-8b0be7780bc3@gmail.com>
References: <1465847065-3577-1-git-send-email-toiwoton@gmail.com>
 <1465847065-3577-3-git-send-email-toiwoton@gmail.com>
 <20160613211227.GG31708@htj.duckdns.org>
 <17cb1a37-47b1-dbd4-6835-efad3cf6c12f@gmail.com>
 <20160613213354.GH31708@htj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=subject:to:references:cc:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=N94/bVujWDULB16+2vyxPv2f0/m9hzijyJdQ86ZWmM4=;
        b=hV/NafmktdoJgbKi0EoRyXQthX79xhHuX57c92lwLjdlPndFHA2+1ntJILgp99JVFU
         BRoCUxlpDL32cB6h4PFC9uYissGxTJOOQZd/40zWx4W8lYBokiowe70JH3LyecPFpF4h
         o//QR/Q2nWd+F51evYYZUnM+eiL++C1qUmsEuPmYOppiJ/gQnFLkTb4BykBJx0oNSfxd
         1rcmsHkhfUjapQjB0ibm/RiAt/3WPfU/EL+EDUQ5VPdY/KD1iqlvi0b6E08TR9d/oPR9
         7BA2iXvFmhiRDngMEy9UeotcK1L7lT4JZxfjDSN1PmzCky1Ecg6jodzxF4HDBg9HKNhG
         fKqQ==
In-Reply-To: <20160613213354.GH31708-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On 06/13/16 21:33, Tejun Heo wrote:
> Hello,
> 
> On Mon, Jun 13, 2016 at 09:29:32PM +0000, Topi Miettinen wrote:
>> I used fork callback as I don't want to lower the watermark in all cases
>> where the charge can be lowered, so I'd update the watermark only when
>> the fork really happens.
> 
> I don't think that would make a noticeable difference.  That's where
> we decide whether to grant fork or not after all and thus where the
> actual usage is.
> 

You mean, increment count on cgroup_can_fork()? But what if the fork()
fails after that (signal_pending case)?

>> Is there a better way to compare and set? I don't think atomic_cmpxchg()
>> does what's needed,
> 
> cmpxchg loop should do what's necessary although I'm not sure how much
> being strictly correct matters here.
> 
> Thanks.
> 

These are not used for any decisions taken by kernel, but by the user. I
have to say I don't know where's the line between strict correctness and
less strict.

-Topi
