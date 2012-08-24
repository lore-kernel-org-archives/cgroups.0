From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 09/10] cgroup: net_prio: Simplify ifdef logic
Date: Fri, 24 Aug 2012 16:42:48 -0700
Message-ID: <20120824234248.GW21325@google.com>
References: <1345816904-21745-1-git-send-email-wagi@monom.org>
 <1345816904-21745-10-git-send-email-wagi@monom.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=oSpICScEbAsgx0gc803g5B/ALWYEcQbs48fk6BKeo64=;
        b=acsPgZSAwlNtxQzMB8ozWzjQksoJBSb5jsqR7lLt4TmR1VRTWT+bDOJCphkj4qYNCJ
         g9C0M95ZFT+NDqm6HthGIt9G+1mcUwMyvkyxyZe0EoW+Zj6U/xkhx03nbruqctE1tVHJ
         5RGJe0t/EwWYPyBbkK748x+nzUR+Aw15oFo6WBmyY8JwkRZkIBPLPIuRZ+I+mosenH1J
         UIrJlsKz3aHJVINUe4qELw8jwKvwEP9AYPrxsAjQF1bsFsw1rbdMmKsf2BKiykzYXtsl
         +Kn0JzUkFt/leSvUi/w2+YMKBeOddBcIAoyLUXu5CX5q+flzUKCRsAxG4BtIH27qpeDH
         4TBg==
Content-Disposition: inline
In-Reply-To: <1345816904-21745-10-git-send-email-wagi-kQCPcA+X3s7YtjvyW6yDsg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Wagner <wagi-kQCPcA+X3s7YtjvyW6yDsg@public.gmane.org>
Cc: netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Daniel Wagner <daniel.wagner-98C5kh4wR6ohFhg+JK9F0w@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Gao feng <gaofeng-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, Jamal Hadi Salim <jhs-jkUAjuhPggJWk0Htik3J/w@public.gmane.org>, John Fastabend <john.r.fastabend-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Neil Horman <nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>

On Fri, Aug 24, 2012 at 04:01:43PM +0200, Daniel Wagner wrote:
> From: Daniel Wagner <daniel.wagner-98C5kh4wR6ohFhg+JK9F0w@public.gmane.org>

Okay, for a few trivial patches, $SUBJ as description is fine but this
series is pushing it too far.  Is this equivalent conversion?  Why
does sock_update_netprioidx() earn an addition ifdef around it?  :(

-- 
tejun
