From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] kselftest/cgroup: Fix gathering number of CPUs
Date: Mon, 14 Nov 2022 11:38:40 -1000
Message-ID: <Y3K1YBoFvZ8Vmi+a@slm.duckdns.org>
References: <20221113114449.18693-1-leitao@debian.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=F3cNtXN2DB64Euf++r92xZMp5o5c66s1GZnHINfFu+k=;
        b=V8q7Aq1Da67HmHyjjYKF4mvnaJAwQFZsxa8vqRh7Qu2wfSYg3MBtNjAAx4ue31AYuk
         bagcYPnIBo5rHRdjT4+VD3n7N1PvjZfwNCCxTJD3isLmrOSTNOcNXDG7ltjvL9JAIaiP
         afYsNemfGGnr/o6LwRDH+n8RLSnk8Wb/9nT+nldCNkmIRJ/NOHVK2IWZRzamVXVMMUaR
         OwdvtnTQapzzea4cb8U00v7/OPaEzL/9z8NfHIz3tbnPeUX04Hfk1mght+W+gUOwxaRl
         vkWZE6SfQviwLqH+urmpFTVI77sNvtVz1OxD0Gq7JvCQaUHc6c3frwCJFpDSBNLv8PTB
         qY1Q==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20221113114449.18693-1-leitao-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Breno Leitao <leitao-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>
Cc: lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leit-M8Ki61LpUEw@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sun, Nov 13, 2022 at 11:44:49AM +0000, Breno Leitao wrote:
> test_cpuset_prs.sh is failing with the following error:
> 
> 	test_cpuset_prs.sh: line 29: [[: 8
> 	57%: syntax error in expression (error token is "57%")
> 
> This is happening because `lscpu | grep "^CPU(s)"` returns two lines in
> some systems (such as Debian unstable):
> 
> 	# lscpu | grep "^CPU(s)"
> 	CPU(s):                          8
> 	CPU(s) scaling MHz:              55%
> 
> This is a simple fix that discard the second line.
> 
> Signed-off-by: Breno Leitao <leitao-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>

Applied to cgroup/for-6.1-fixes.

Thanks.

-- 
tejun
