From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHv3 8/8] cgroup: Add documentation for cgroup namespaces
Date: Wed, 11 Feb 2015 00:17:04 -0500
Message-ID: <20150211051704.GB24897@mtj.duckdns.org>
References: <20150107224430.GA28414@htj.dyndns.org>
 <878uhe42km.fsf@x220.int.ebiederm.org>
 <20150107230615.GA28630@htj.dyndns.org>
 <87fvbm2nni.fsf@x220.int.ebiederm.org>
 <87y4peyxw5.fsf@x220.int.ebiederm.org>
 <20150107233553.GC28630@htj.dyndns.org>
 <20150211034616.GA25022@mail.hallyn.com>
 <20150211040957.GC21356@htj.duckdns.org>
 <20150211042942.GA27931@mail.hallyn.com>
 <87oap1qbv3.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=gvFspu5C+i+lxSEc2oNJQN8W7XwLU8R2ACwt8zVFxqc=;
        b=yMGYYdP4E/VyIQ/m4PLcl4QimGacfEqi451l/4Ax8SRyatcGhH+rOhcXqsX+9rTzwm
         TpjMia/xWHh7AFG6pFQZmhOifLKZCsq2Z7uuK0pS0FdWX5Kc6TKZz6a6lqE1XYtllgTy
         zOvEBgpkD4c9zM34HaYf3IIWQAUdR9rYZ1mzt8NqqC7GJXcGOuZULMCs33WR0zWHWYDc
         X7bdZ7QbOz+B8DgWCttP5UqFySulvtc388+VlgcAzLkIA2Ysz0CTSg+Uryx6tntJv7UR
         Bl3F25HiaKTBFeH8oE3MgiJ58+MblqNRY7F6CCl2Ls0+v0unWTp+gCiFrypmrsUVSKKf
         Ailg==
Content-Disposition: inline
In-Reply-To: <87oap1qbv3.fsf-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, cgroups mailinglist <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Hey,

On Tue, Feb 10, 2015 at 11:02:40PM -0600, Eric W. Biederman wrote:
> A slightly off topic comment, for where this thread has gone but
> relevant if we are talking about cgroup namespaces.
> 
> If don't implement compatibility with existing userspace, they get a
> nack.  A backwards-incompatible change should figure out how to remove
> the need for any namespaces.
>
> Because that is what namespaces are about backwards compatibility.

Are you claiming that namespaces are soley about backwards
compatibility?  ie. to trick userland into scoping without letting it
notice?  That's a very restricted view and namespaces do provide
further isolation capabilties in addition to what can be achieved
otherwise and it is logical to collect simliar funtionalities there.

Thanks.

-- 
tejun
