From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/2] cgroup: add sparse annotation to
 cgroup_iter_start() and cgroup_iter_end()
Date: Tue, 27 Dec 2011 08:52:48 -0800
Message-ID: <20111227165248.GB17712@google.com>
References: <1324964786-19052-1-git-send-email-kirill@shutemov.name>
 <1324964786-19052-2-git-send-email-kirill@shutemov.name>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=visKLWkv2DtCu+bQLw2kG0b2ul1CTu3Cu0kLHRBFzcc=;
        b=GzetC/2EJGWviCWjlb6YTUxnP2bTYNN5eTsyQvaQc2kJVeLlDMQzGDuoKUN3HWxpyJ
         SPSynFxo4/jgZcWxLUOzEU4wHnqmqXt6DV7KDUm1BBZM6D7KFgdef4d+7X7n4acKOfyC
         C6J5J9+BWCg2ytPfOoiHA19dL1xZp2vpWu7nU=
Content-Disposition: inline
In-Reply-To: <1324964786-19052-2-git-send-email-kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Paul Menage <paul-inf54ven1CmVyaH7bEyXVA@public.gmane.org>

On Tue, Dec 27, 2011 at 07:46:26AM +0200, Kirill A. Shutemov wrote:
> From: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
> 
> Signed-off-by: Kirill A. Shutemov <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>

Applied 1-2 to cgroup/for-3.3.  Thank you.

-- 
tejun
