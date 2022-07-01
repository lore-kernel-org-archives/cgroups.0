From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup-v1: use find granularity format identifiers to
 make /proc/cgroups show pretty
Date: Fri, 1 Jul 2022 10:09:40 +0900
Message-ID: <Yr5JVHhSUCrbT8OH@mtj.duckdns.org>
References: <20220630082539.83602-1-linf@wangsu.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ygHT2jAw914f43IVltgvjT9GLQcCfN55KKGJRNI/BxE=;
        b=TCbSrA2CBbCo9r/tWWtCU9TspHb5SREc2B0ylUhPwlb2whHLQfZFQzJi65Z+vfWSbd
         uP2dWtdU3KgH+GVGXOSsufjmUvdD/CJNe+3EYzSboinSUektABBkXvJSdsCgGT20YU8+
         /Ynz+i5I93xJUPaVJwlt0gN21yvCKCPf/rOr7C8TBfdxzRLoYG9ThANACmZ7cBNE9Wha
         OyJM9vDGT+FDZOcejtNfzZtlyEsfRsSdwNxn3gAwmGoM0YPxIc/eqkUhHyCZeaVJiZiz
         8AKXVAsicGkNEF5XMjb8Lw81j9YpQH6mA/pQQQYurQ1VI+TfBB92M0uLtCvqQvybytzr
         hRag==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20220630082539.83602-1-linf-VqLewplIU37QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Lin Feng <linf-VqLewplIU37QT0dZR+AlfA@public.gmane.org>
Cc: lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Jun 30, 2022 at 04:25:39PM +0800, Lin Feng wrote:
> The listing subsys info is unaligned with the header columns and we can
> make the output more intuitive to read by specifying "left alignment"
> and "fixed length" format styles for seq_printf.

This has been proposed before but the file is useful only in cgroup1
which is in maintenance mode and the format has been like that since
forever. Given that there's some chance that it can break dumb
parsers, the choice has been to leave it alone. It's such a dumb file
format to begin with and just leaving it to wither and die seems to be
the right direction.

Thanks.

-- 
tejun
