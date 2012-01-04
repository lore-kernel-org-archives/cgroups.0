From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [patch] cgroup: move assignement out of condition in
 cgroup_attach_proc()
Date: Wed, 4 Jan 2012 07:38:43 -0800
Message-ID: <20120104153843.GM31746@google.com>
References: <20120104072429.GF30978@elgon.mountain>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=gfm3PLppWWDEaiL2qRfmANKnvd4f39/4piRJJRIkCgE=;
        b=gG0gO++YgTpt98ld/IQN2Uj2jpgzHxm7vZ2X8kmEh2G48i79z7eqkPEZr/h7KFY10J
         GLh8gkoKKQJOfwmf1EuGkrcBd74xa6C/LgKaPLnHEZu0eHBXHkmpStD9i14Hg0T8DRRM
         XqTU+c7JHLRofUmWYMo1wxDgA4wst9OnuDX5M=
Content-Disposition: inline
In-Reply-To: <20120104072429.GF30978-mgFCXtclrQlZLf2FXnZxJA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Jan 04, 2012 at 10:24:29AM +0300, Dan Carpenter wrote:
> Gcc complains about this: "kernel/cgroup.c:2179:4: warning: suggest
> parentheses around assignment used as truth value [-Wparentheses]"
> 
> Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-3.3.  Li, applied w/o your ack as it's trivial.

Thanks.

-- 
tejun
