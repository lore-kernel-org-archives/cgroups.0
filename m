From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: WARN in __mark_inode_dirty when mounting a filesystem
Date: Mon, 23 Nov 2015 16:21:30 -0500
Message-ID: <20151123212130.GE19072@mtj.duckdns.org>
References: <56533374.2090807@kyup.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=gMgVtdjjp5eaKtQArjuX5WYsM3XM3KaCFXsyau4gBsM=;
        b=YLR333ninHqCTLsVsdPX43LFR3cmHhTFzuGXxGtfqDd060EzsLaUhd24JpOX/bJCbw
         DZkUrSUNjyD0rvMR2KvHjkb3B0B7k/vLMiiaCsLjbR50KTajEK5WWcCP+FJaCeDajekK
         vl9uuASet50XbZrFBpotXxVniKndmpUGyJIEYIBh+Wp+FdaCfjC/JPPDBGCxhogWXhcZ
         3zQDeyuPH1TrP1Rr7TAZsQjb7iOvhkCUPDt/AaAm06kO3GSSYtto0A7PqKE5vPBVYw6V
         jMyxaDb/T3Oc8boiHvM5OfYV2XIVXhpQ3H3eZzn+5kieJQQE5SzuLVMQUHBSBxBu3TOy
         Gzww==
Content-Disposition: inline
In-Reply-To: <56533374.2090807-6AxghH7DbtA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Nikolay Borisov <kernel-6AxghH7DbtA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>

Hello,

On Mon, Nov 23, 2015 at 05:40:36PM +0200, Nikolay Borisov wrote:
> Hello Tejun, 
> 
> On one of my servers I recently hit the following warn: 
> 
> 182317.101584] ------------[ cut here ]------------
> [182317.101753] WARNING: CPU: 7 PID: 13192 at fs/fs-writeback.c:2080 __mark_inode_dirty+0x20a/0x350()
> [182317.102032] bdi-block not registered
> [182317.102192] Kernel panic - not syncing: panic_on_warn set ...
>                 
> [182317.102474] CPU: 7 PID: 13192 Comm: mount Not tainted 4.2.5-vanilla1 #1

Is the problem reproducible?  If so, can you please see whether the
following patch makes any difference?

 http://lkml.kernel.org/g/1448054554-24138-1-git-send-email-idryomov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

Thanks.

-- 
tejun
