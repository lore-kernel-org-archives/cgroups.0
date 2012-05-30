From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH v3 3/6] expose fine-grained per-cpu data for cpuacct stats
Date: Wed, 30 May 2012 17:26:12 +0400
Message-ID: <4FC61FF4.4050304@parallels.com>
References: <1338371317-5980-1-git-send-email-glommer@parallels.com> <1338371317-5980-4-git-send-email-glommer@parallels.com> <CAPM31RJanAvDB+pZ+h5J3W6KXvAwPgbbeXgw6C_56tx_Mc+cgA@mail.gmail.com> <4FC6107F.9020802@parallels.com> <CAPM31RJ7s+pNciOEnsfXRU9xCwnUano1k8CTEUuCjsSN5n0-1Q@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAPM31RJ7s+pNciOEnsfXRU9xCwnUano1k8CTEUuCjsSN5n0-1Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Andrew.Phillips-xheW4WVAX9Y@public.gmane.org, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

On 05/30/2012 04:48 PM, Paul Turner wrote:
>> >  Now, if you guys are okay with a file per-cpu, I can do it as well.
>> >  It pollutes the filesystem, but at least protects against the fact that this
>> >  is kmalloc-backed.
>> >
> As I prefaced, I'm not sure there's much that can be trivially done
> about it.  This is really a fundamental limitation of how read_map()
> works.
>
> What we really need is a proper seq_file exposed through cftypes.

Tejun, would you be okay with an interface that exports somehow the raw 
seq_file in cgroups ?

This way we could call s_show for each cpu and get away with the memory 
usage problem, I presume
