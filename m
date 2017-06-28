From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 3/3] cgroup: implement "nsdelegate" mount option
Date: Wed, 28 Jun 2017 14:44:41 -0400
Message-ID: <20170628184441.GC27833@htj.duckdns.org>
References: <20170625042717.GA14158@htj.duckdns.org>
 <20170625042759.GA9644@htj.duckdns.org>
 <20170625042838.GB9644@htj.duckdns.org>
 <20170627183028.GF2289@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=YwN8cybHWya9htBpFDfg+uANOkdaxNyt9ndSRRg1C0Q=;
        b=ibTBS5F2GZGbAe8f+y/h/vWK39uTV4SLJ06paNeZIKDgLxvSpBxjvUFTvY31JEoYoT
         9DfkgwxTrFJrLcWf/r7G+KVvxmWigxOfKZkVoFkIXuyR6trKuEYDhmcqin0erEJ8YevF
         EptYlhGRM7d4/jAlRheENcxxqtXhgCFwFuQJs3OzOogEdUXm8wagx2dSrhxYOzQgxH9c
         VORLlxD2sWe5g+LK3MoQebP9wuPYC6wdF61ky3ShyZvlNPJgFECkcECJEoL/P6BNxENL
         vW3DqQO3DkJpAGH97vrb2mjmGdSiht7hae7Qq7+6F3lm6JT5ck2AWkqfPl7kmWV4JxOL
         K3xQ==
Content-Disposition: inline
In-Reply-To: <20170627183028.GF2289-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Aravind Anbudurai <aru7-b10kYP2dOMg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Serge Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Eric Biederman <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>

On Tue, Jun 27, 2017 at 02:30:28PM -0400, Tejun Heo wrote:
> Currently, cgroup only supports delegation to !root users and cgroup
> namespaces don't get any special treatments.  This limits the
> usefulness of cgroup namespaces as they by themselves can't be safe
> delegation boundaries.  A process inside a cgroup can change the
> resource control knobs of the parent in the namespace root and may
> move processes in and out of the namespace if cgroups outside its
> namespace are visible somehow.
> 
> This patch adds a new mount option "nsdelegate" which makes cgroup
> namespaces delegation boundaries.  If set, cgroup behaves as if write
> permission based delegation took place at namespace boundaries -
> writes to the resource control knobs from the namespace root are
> denied and migration crossing the namespace boundary aren't allowed
> from inside the namespace.
> 
> This allows cgroup namespace to function as a delegation boundary by
> itself.
> 
> v2: Silently ignore nsdelegate specified on !init mounts.
> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Aravind Anbudurai <aru7-b10kYP2dOMg@public.gmane.org>
> Cc: Serge Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
> Cc: Eric Biederman <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>

Applying 2-3 to cgroup/for-4.13.

Thanks.

-- 
tejun
