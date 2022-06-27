From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] cgroup.c: remove redundant check for mixable cgroup in
 cgroup_migrate_vet_dst
Date: Mon, 27 Jun 2022 18:09:52 +0900
Message-ID: <Yrlz4E4QbrzdOfMF@mtj.duckdns.org>
References: <20220621092358.223594-1-linf@wangsu.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jzEXo2wNJKuAXzdzPYSnlSN8fixwVSEGJI0x/W31JkM=;
        b=hU4DhJ+W7BPhJkIWmS8d8NgVX/6O0gsSZ6+OJHBNigkHfBGv3KGB2PpoPYMekkqEKc
         G9arIfzZLle4EjKLrbn5G2gG8JvZbK84yRMfRQ76bqdRegXh9PPvm7dqC6NfedlYeZSL
         hcuE2zj95GukfZvGBs6RDpr9Wac/bRrAtRMWrspwqj9gAJrrBwFoiDbGa/J09EoJrN7n
         P8VCUxO15woow6TQJpqoRmYZ+DqaOKhJ750PBDSuTCbHaeIOE4UVtVznqK5v7qwEk5XX
         A/7Ij+mmkNcQH6B8JpcNYPdDrsShy0J34i2C3DiXovN91e2VObvlkiVCM5/AKR/+kljp
         PMIA==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20220621092358.223594-1-linf@wangsu.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Lin Feng <linf@wangsu.com>
Cc: lizefan.x@bytedance.com, hannes@cmpxchg.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Jun 21, 2022 at 05:23:58PM +0800, Lin Feng wrote:
...
> so explicitly checking in cgroup_migrate_vet_dst is unnecessary.
> 
> Signed-off-by: Lin Feng <linf@wangsu.com>

Applied to cgroup/for-5.20.

Thanks.

-- 
tejun
