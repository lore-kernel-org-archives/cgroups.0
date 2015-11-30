From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/8] kernfs: Add API to generate relative kernfs path
Date: Mon, 30 Nov 2015 17:53:18 -0500
Message-ID: <20151130225318.GD9039@mtj.duckdns.org>
References: <1447703505-29672-1-git-send-email-serge@hallyn.com>
 <1447703505-29672-2-git-send-email-serge@hallyn.com>
 <20151124161630.GL17033@mtj.duckdns.org>
 <20151127052511.GA25490@mail.hallyn.com>
 <20151130151147.GG3535@mtj.duckdns.org>
 <20151130183758.GA25433@mail.hallyn.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=Z5zdSnu6Ch/elMAgb/vD/U6+iYM0p8cSkmmyy92HZuw=;
        b=xtoN+OASzCn8C54BkHwkYXY0MhklEeaJxlO0azDmzKyXvaU87U8V6mj4AwuI0UrrAc
         vpa040zMukXXwj3AvaYSLPxDAR36G2XO79ZfAsi4oXpkGXpk5b5XzfH4zzcVUoSqg/3u
         xPtD0rWN+vmDTk+tdOnNiP6RriRLwPcEqEhk6z8G5VPGrWfr5ZPMe+JIW6CpqihaNQTC
         gkIBk/IXd6KoQ2tcDKgCg9NJeufzz95lLOjJW9af37MYDFarOBm8M0NxXqD9vcdhXiTz
         ex4Kdr7z63i19UmUVoSvCjbtFOax3imuyVTsMF5xYIcrgU4g8wi6dVcl5+X7lim9UzbQ
         9x7Q==
Content-Disposition: inline
In-Reply-To: <20151130183758.GA25433@mail.hallyn.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Serge E. Hallyn" <serge.hallyn@ubuntu.com>
Cc: serge@hallyn.com, linux-kernel@vger.kernel.org, adityakali@google.com, linux-api@vger.kernel.org, containers@lists.linux-foundation.org, cgroups@vger.kernel.org, lxc-devel@lists.linuxcontainers.org, akpm@linux-foundation.org, ebiederm@xmission.com

Hello, Serge.

On Mon, Nov 30, 2015 at 12:37:58PM -0600, Serge E. Hallyn wrote:
> > Yeah, I agree but the name is kinda misleading tho.  The output isn't
> > really a relative path but rather absolute path against the specified
> > root.  Maybe updating the function and parameter names would be
> > helpful?
> > 
> 
> Ok - updating the comment is simple enough.  Though the name/params
> kernfs_path_from_node_locked(from, to) still seem to make sense.  Would
> you prefer something like kernfs_absolute_path_from node_locked()?  I
> hesitate to call 'from' 'root' since kernfs_root is a thing and this
> is not that.

Hmmm... I see.  Let's just make sure that the comment is clear about
the fact that it calculates (pseudo) absolute path rather than
relative path.

Thanks.

-- 
tejun
