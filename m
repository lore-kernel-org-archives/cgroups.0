From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH -next] selftests: cgroup: Remove redundant if statements
Date: Mon, 31 Jul 2023 13:42:51 -1000
Message-ID: <ZMhG-yPZttsOY7y9@slm.duckdns.org>
References: <20230731134205.2723657-1-lizetao1@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690846973; x=1691451773;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=E7hg3VxRoU08q5hPKNlW6YF7vv+fBSVfAKzSjCaYJbQ=;
        b=Czs/46fAFXwgUSVna61zgI+/AxchGe8XwfL1ggFEGfpPl2ji9b6lPJk7MbHlHPha1i
         bR/0MaWtAeYrdIpEYKXnBVuIpkC8+faTzzvGpr2m1/IL5Twp3uFyKcpqWvyCC86GOp/w
         W2rnvx24/yGHM9uQmVmN1hPNRNBKX9nPGUY0I+NI/87ViXCISG0j5NeEw5OySKCgmqzu
         fpPFT1FXlu9DwCY22hs9ZVE2X9oPaKnYxyErsmZI4KaiVQdU5QY9qFTOdZCGK8OethMX
         UA5zTWztIddDPYXoWBi+LYrrwEEzI4lvioY9AQ0TlhUJgZQzIpo3NB5EKNmC+VTYrntA
         YXWA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20230731134205.2723657-1-lizetao1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zetao <lizetao1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Jul 31, 2023 at 09:42:05PM +0800, Li Zetao wrote:
> There is a warning reported by coccinelle:
> 
> ./tools/testing/selftests/cgroup/test_zswap.c:211:6-18: WARNING:
> 		Unsigned expression compared with zero: stored_pages     <     0
> 
> The type of "stored_pages" is size_t, which always be an unsigned type,
> so it is impossible less than zero. Drop the if statements to silence
> the warning.
> 
> Signed-off-by: Li Zetao <lizetao1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Looks fine to me but the zswap test addition is going through akpm's tree, I
think, so probably best to repost it to Andrew.

Thanks.

-- 
tejun
