From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cpuset: Clean up cpuset_node_allowed
Date: Fri, 17 Mar 2023 11:37:41 -1000
Message-ID: <ZBTdpYaBG2nJmWbL@slm.duckdns.org>
References: <9953284e-05da-56b0-047d-ecf18aa53892@redhat.com>
 <20230228083537.102665-1-haifeng.xu@shopee.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679089063;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VM4L650jvOHnOrzjxyybDkCmQtbFyLFT1T/BqqmyWcU=;
        b=BMtstbKLHuH8Y2UCzCOd8xm/eCyHo7c5eIYlFb96xgHM115JNQM+OFQ4k59hUkiBnE
         ftqWS3pKGpJsbiYoNoKCWwmz5P18p9hMSLR6skLG3iXxHg4OcB66U65UhRT0YDJ0d3CS
         Xs7YKbDPjetM1g4ow3EMHRk5kYw8gNzC5t7Q/4cOtnFzaZnaWjciLtLKPnC2R+8i0L/5
         2fmcfzvbGluZoFNhqL9IWuH78tneHzxy1LGIdJR8mWsc3YufBwxahT4Yz2GsXRVCRkhB
         LeNU1/n9TxwTTM5LUq83iz4V24ouqBqsjeuXJwFOu+OBPySm82YBfjILXj532EBjLu+e
         xW8A==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20230228083537.102665-1-haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Haifeng Xu <haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>
Cc: longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Feb 28, 2023 at 08:35:37AM +0000, Haifeng Xu wrote:
> Commit 002f290627c2 ("cpuset: use static key better and convert to new API")
> has used __cpuset_node_allowed() instead of cpuset_node_allowed() to check
> whether we can allocate on a memory node. Now this function isn't used by
> anyone, so we can do the follow things to clean up it.
> 
> 1. remove unused codes
> 2. rename __cpuset_node_allowed() to cpuset_node_allowed()
> 3. update comments in mm/page_alloc.c
> 
> Suggested-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Haifeng Xu <haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>

Waiman, can you review and ack?

Thanks.

-- 
tejun
