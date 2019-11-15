From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH -next] writeback: fix -Wformat compilation warnings
Date: Fri, 15 Nov 2019 06:55:40 -0800
Message-ID: <20191115145540.GP4163745@devbig004.ftw2.facebook.com>
References: <20191114192118.GK4163745@devbig004.ftw2.facebook.com>
 <9D52EBB0-BE48-4C59-9145-857C3247B20D@lca.pw>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Zw8wOIY8mNW318y4fP6Jxq3gT3vqgJzWHMf4m4vqBkE=;
        b=LOwhHWT22OBlnSHpiAikAbBxvHi30RL+IBBMK3PZmWUq7XqPuvbKJEfQy7BEfPpdlv
         PDNIAjAA4N3FXDU8H58bSN56ATiyHLx4x8buRO+Hxlba3zpFVM2r4JpDGyuTGGGwi7aF
         FYRhIQMJkwzlYGlsYp/gg7t5RbyFY5War7OLnNH1qNaMHu47Q4FY0jB8nkU2JFHldK5K
         wq7+4tF720mjj22BlYNKBQe2Ofr4DGbLwH9EOy+rZqbjGNnlS1GSHHQT6vC8l0T12R6K
         26UFB0OGwj7m2Qzbvc6mS9htstuHMHdO2zhxhXzalpDma/QrGMslY9aCcRvKcNMt3Zqe
         07jA==
Content-Disposition: inline
In-Reply-To: <9D52EBB0-BE48-4C59-9145-857C3247B20D@lca.pw>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Qian Cai <cai@lca.pw>
Cc: jack@suse.cz, gregkh@linuxfoundation.org, cgroups@vger.kernel.org, heiko.carstens@de.ibm.com, gor@linux.ibm.com, borntraeger@de.ibm.com, linux-s390@vger.kernel.org, axboe@kernel.dk, linux-kernel@vger.kernel.org

On Thu, Nov 14, 2019 at 07:26:21PM -0500, Qian Cai wrote:
> 
> 
> > On Nov 14, 2019, at 2:21 PM, Tejun Heo <tj@kernel.org> wrote:
> > 
> > Acked-by: Tejun Heo <tj@kernel.org>
> 
> Tejun, suppose you will take this patch via your tree together with the series or should I Cc Andrew who normally handle this file?

Patches in this area usually goes through Jens's block tree.

Thanks.

-- 
tejun
