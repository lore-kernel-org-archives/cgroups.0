From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 08/21] blkcg: blkg_conf_prep()
Date: Wed, 28 Mar 2012 15:53:56 -0700
Message-ID: <20120328225356.GA11059@google.com>
References: <1332975091-10950-1-git-send-email-tj@kernel.org>
	<1332975091-10950-9-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=sender:date:from:to:cc:subject:message-id:references:mime-version
	:content-type:content-disposition:in-reply-to:user-agent;
	bh=sy7dONj3BSxKtZdiYenrsZIrgHLs0NNDtbu8k73UJW0=;
	b=VAuBBMulXmWYtAy3SUPC2axQ3DheZ2jAduIdMh8WeeS17kS/gsizdxrPBC8J0NSe9r
	t8NyUT6RGmw7D2rgYSVIquvCJlrXqrbXaZZnzQe38vDuWZguflYMBTU6/jnChtxYDbEL
	LGvw3dRn/gWAjYDiVQXIaj/Dfs/7D/PulNx+isTU2iNb0x3Qa7rlJR9OWClrdOvv9ZvI
	TIIzwVlUqyrFiiOgsPmvAK3jtEvNUPLEmj4pbRdVEGB3nt512rxJNf5KWnSy6b4FCaTa
	IbqdYlSbXcIIo19SEOor7eTZwy0ZoHtvp58FDOKayawabyR6Lz5YLxyqGBH1R4gsD6jF
	qnwQ==
Content-Disposition: inline
In-Reply-To: <1332975091-10950-9-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>, 
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: ctalbott-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, rni-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org

Oops, $SUBJ should have been "simplify blkg_conf_prep()".

-- 
tejun
