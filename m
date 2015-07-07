From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 4/5] kernfs: implement kernfs_path_len()
Date: Tue, 7 Jul 2015 11:12:18 -0400
Message-ID: <20150707151218.GB23362@mtj.duckdns.org>
References: <1436281823-1947-1-git-send-email-tj@kernel.org>
 <1436281823-1947-5-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=Y2O2XVwk/Iw+xEBZFKVsBJqTZ06kxbsyDaRLht/5nLk=;
        b=RHnDHI68i4TkcqZs8kxO2FX3iQSlhrvGI112ExWZv6U+CasLmy+DLBRs6HUvMB8slk
         fVhO9NXFyNytIwQMxPW76QFl3zsg5EQjVUJ79Z+Dg+A4PInxFbWXAdjEs0UEmSB23XGO
         e6TrKMMqV8OFsfrWJMvIQ5AVW6RYA3b+pUXU35lxi3Au4g2TyZk+NSkR7RO6PN+CYfsF
         erMFj4DtV5cX30ce/NTF3uLThNEYPfZgAZwEy+iPUwmUxxmXqQkNNX1m5mqPcjTDEYyr
         b4nWwUn83iI6P6W1zGC4NqgN+kDuIxTyXq2fm9FTc9W1MpCC0X8+N0g6yrDr+LKUgwe9
         tPEg==
Content-Disposition: inline
In-Reply-To: <1436281823-1947-5-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: jack@suse.cz, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, kernel-team@fb.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>

On Tue, Jul 07, 2015 at 11:10:22AM -0400, Tejun Heo wrote:
> Add a function to determine the path length of a kernfs node.  This
> for now will be used by writeback tracepoint updates.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Greg, would it be okay to route this together with writeback changes?

Thanks.

-- 
tejun
