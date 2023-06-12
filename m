From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup/cpuset: remove unneeded header files
Date: Mon, 12 Jun 2023 06:53:17 -1000
Message-ID: <ZIdNfTyyoaZ5Ybpr@slm.duckdns.org>
References: <20230610064138.1472319-1-linmiaohe@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686588795; x=1689180795;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8ozLmxcHZko0uff1gJa7G1QuMp/af47NfMEu+aumDRk=;
        b=asziyJYziIWdTbh13EtSN26YuTiEk9fqzksOwuGlBXMDRQlxXgFKs0Cmz8sA0AQvQI
         te9sSY4n2RSu097TwpQepts33BOL4AM4tWhSoq16SFnU/pUi4Gh9GV4O3FXl8uMZI4Kc
         PuO8tC367euVqlNHJthw0XZD4jTE7GPu3ZBE6ZCxK6iAaz22sJ+hbgv3oMcaSM/qvJPo
         m1GKXkaX0/tTej1Ev5OnP599v1D0QEgJAUf8werx4bdtAc9GUfy7fdC7hVu22CipHpaL
         AMb/5zNHy/HHh5G6pgp1SvC96x0k03yWCQ/jTmtnIqF0dwU9VflYqlslyDwyXtDw6l1n
         ZKCg==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20230610064138.1472319-1-linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sat, Jun 10, 2023 at 02:41:38PM +0800, Miaohe Lin wrote:
> Remove some unnecessary header files. No functional change intended.
> 
> Signed-off-by: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-6.5.

Thanks.

-- 
tejun
