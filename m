From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/3] cgroup: remove extra calls to find_existing_css_set
Date: Fri, 20 Jan 2012 16:08:42 -0800
Message-ID: <20120121000842.GB2908@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1325654312-32477-1-git-send-email-msb@chromium.org>
 <1325654312-32477-3-git-send-email-msb@chromium.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=rZRcHV2xEfLO8zX8sM/OhY7xzBIVu2JBfAIcDCFhMkk=;
        b=Dv/ow9mBJK26zOoWZpZobIy6sMh5FHUy4X8Vnqhd6ruyXVwTZzwmKLjDF1kPm/OBbK
         FKdhwbLE2hYRwQMZ18JAXVG03A1sAJXDwO76sG9io6ZoQ6n6uAo9EC968G4voNtiKoKB
         ZlhU0yiygK/0KlSG3jNg59g0CzwbtGhZeUdlM=
Content-Disposition: inline
In-Reply-To: <1325654312-32477-3-git-send-email-msb-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mandeep Singh Baines <msb-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Paul Menage <paul-inf54ven1CmVyaH7bEyXVA@public.gmane.org>

On Tue, Jan 03, 2012 at 09:18:32PM -0800, Mandeep Singh Baines wrote:
> +out_put_css_set_refs:
> +	if (retval) {
> +		for (i = 0; i < css_set_refs; i++) {
> +			tc = flex_array_get(group, i);
> +			put_css_set(tc->cg);

Why not the following

	for (i = 0; i < group_size; i++) {
		tc = flex_array_get(group, i);
		if (tc)
			put_css_set(tc->cg);
	}

and remove css_set_refs?

Thanks

-- 
tejun
