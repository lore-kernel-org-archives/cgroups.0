From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2] device_cgroup: check if exception removal is allowed
Date: Mon, 5 May 2014 11:16:21 -0400
Message-ID: <20140505151621.GJ11231@htj.dyndns.org>
References: <20140424193254.GR29214@redhat.com>
 <20140502152930.GF10204@htj.dyndns.org>
 <20140505151431.GK29214@redhat.com>
Mime-Version: 1.0
Return-path: <stable-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=vJfT0K1M3F4xhd7J0EPrGoJSOiB7L1uL9ys498C/K5g=;
        b=WiyCOUDlniUmzgfrPZsTi31qVguJiNZViPfTkC7djZDeQVamRGZjcq6+IcBcDioS23
         kHs6iP2VmNXvd+e//H+98lJ6DpKxTP8mWAyxIcpTAHMg8bm60LP7Fas0Ea5aDrTwStHD
         82SIOerYRiCMpbjryI/E7EhYczzY9a0m0It/GvXu8omDYvDaY3OpQTbzndWHVysNQ/L0
         qE/NwpqcAFPVUlHsVDnaM/1UfCQlHUtyB9OSuSG3VpVoYvRorh6c2NVIBD1npRCJX2aD
         fYjF9XeP39297bjTX7qsYo5x7m9Lhk89GqhmatfHv9MGThrWFAL7XzZ+xfUAY7htyYJh
         /HCA==
Content-Disposition: inline
In-Reply-To: <20140505151431.GK29214@redhat.com>
Sender: stable-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aristeu Rozanski <aris@redhat.com>
Cc: cgroups@vger.kernel.org, Serge Hallyn <serge.hallyn@canonical.com>, Li Zefan <lizefan@huawei.com>, stable@vger.kernel.org

On Mon, May 05, 2014 at 11:14:31AM -0400, Aristeu Rozanski wrote:
> +/*

/**

> + * parent_allows_removal - verify if it's ok to remove an exception
> + * @childcg: child cgroup from where the exception will be removed

I'll wait for v3.

Thanks.

-- 
tejun
