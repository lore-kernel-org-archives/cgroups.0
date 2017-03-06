From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: Fix indenting in PID controller documentation
Date: Mon, 6 Mar 2017 14:46:57 -0500
Message-ID: <20170306194657.GC19696@htj.duckdns.org>
References: <20170217174411.8475-1-tklauser@distanz.ch>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=NNpfVcYXm+qJ5xlna766LP5WJNz95MNqwWARhzMjJWw=;
        b=Obcos+wXkgNK1bbCqSnQqY4d5HL2WC9yjBA1p/q2Xg2UL55pO7SoobQ/duvlGSlbO4
         Y1FSn5ukPIXXE1YaTbLEH5PztZpt+AmUS1LN5mferZY7z5EK05TIYyq0of8rI9UPGcjI
         OG59PRM+PDJ+THytdCDQE+CbGWHyUdSHjjeG/yAqF0uDiA2V10cyp3oLQj9fe923JYQm
         xYk+yok2+yobrX1HNtp9cn6yyL49oLSrtee6kS2d6pB4nb82+IHUUtNHZv2aUpp3w1IA
         27SfFRfNJ4B8X6MHyesnMWGBY1gXBf58pZcSOBpOTTjkptUQXfvopD/Dqc3Sak2MPdpa
         TE1w==
Content-Disposition: inline
In-Reply-To: <20170217174411.8475-1-tklauser-93Khv+1bN0NyDzI6CaY1VQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tobias Klauser <tklauser-93Khv+1bN0NyDzI6CaY1VQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Feb 17, 2017 at 06:44:11PM +0100, Tobias Klauser wrote:
> Follow the common documentation style in the file and indent the
> interface file description by a tab instead of just a space.
> 
> Signed-off-by: Tobias Klauser <tklauser-93Khv+1bN0NyDzI6CaY1VQ@public.gmane.org>

Applied to cgroup/for-4.11-fixes.

Thanks.

-- 
tejun
