From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] mountinfo: implement show_path for kernfs and cgroup
Date: Mon, 9 May 2016 12:19:13 -0400
Message-ID: <20160509161913.GF7110@mtj.duckdns.org>
References: <20160509145955.GA12316@mail.hallyn.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=NlrI92cNXvo7D9/jhXPMf31HYtKq29tFffnQoazade0=;
        b=ZWzvWgIjMfxANqG+TFRP6h+B+7OfbHM7e+DZPaV0h33UFP4JlF3jI0LgJ+jyRaELMC
         mgZKSdhJwMB6edd9IYrdOFxNXBpcKdH6fGGzr/LMaxkJVWeA/ywvBjqcFNbUpLc4qUrq
         CZXo62PHUDYCGuzNrldjX2c5s4D8aVJE6W5n+nb8UkOPWSrks3eOoD/fs1JlQ67gpcsY
         Qr/78Y8hGpk4CCqbze8RP2g3TlO8yVGwcF8dR8FUT59LNXRINkig3ct4+p0Wg2+GyP4B
         wGytDH6MwqMtEhKFozS285T48w0ugCoPm/h+lPb7DVCIC3wupA576NNVG0pgsJD01QEq
         4yGA==
Content-Disposition: inline
In-Reply-To: <20160509145955.GA12316-7LNsyQBKDXoIagZqoN9o3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org

On Mon, May 09, 2016 at 09:59:55AM -0500, Serge E. Hallyn wrote:
> Patch summary:
> 
> When showing a cgroupfs entry in mountinfo, show the path of the mount
> root dentry relative to the reader's cgroup namespace root.

Applied to cgroup/for-4.6-fixes w/ subject updated.

Thanks.

-- 
tejun
