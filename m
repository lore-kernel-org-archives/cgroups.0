From: Topi Miettinen <toiwoton-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC 02/18] cgroup_pids: track maximum pids
Date: Sun, 17 Jul 2016 20:11:31 +0000
Message-ID: <3b03822f-c5d0-5b84-79c3-edeb8e78e2dd@gmail.com>
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
        bh=UD/XTfS2exJ1V59tPZH8sgNT8TZq9HkUmOetWYudKUg=;
        b=CoZW/JcH3TIqwJybFnEvRonNpq9Py7vgp3KyWz0TiVb1VIRS0kVL2RNjpoaj8PZHcU
         3OwXjDGGsnVSH86+MYbNscRNVHCYW6B5frdLOCDl+TdFa+dGVmdT8gs7WUncWtCb2dC+
         2+bvb2OhS7mTYyzmk+qclt4k7e/VdOM7fwPmmtNFDen7bK2yJeEsklwgSiwSyKOlDpYr
         qEOGUr4zA5ejwTjjeOezD4AHCaJiimnyipVh+A5w6rTeVwBBp82Xb8z9ivpIQbjKnCUo
         KogJguOvM35B5bMX0jm5W/CXbFNkOwR5xLQErMLyKTYl8ZFgZcPPf94E12MVeqGtqjr7
         1bBw==
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

I tried using only charge functions, but then the result was too low.
With fork callback, the result was as expected.

-Topi

> 
>> Is there a better way to compare and set? I don't think atomic_cmpxchg()
>> does what's needed,
> 
> cmpxchg loop should do what's necessary although I'm not sure how much
> being strictly correct matters here.
> 
> Thanks.
> 
