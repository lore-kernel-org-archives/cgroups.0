From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: CGroup Namespaces (v8)
Date: Fri, 1 Jan 2016 11:14:14 -0800
Message-ID: <CAPcyv4iEdP+jMVSFquqCgMiXFgzOSaW40NdG6y2tHRgSKxaOcQ@mail.gmail.com>
References: <1450844609-9194-1-git-send-email-serge.hallyn@ubuntu.com>
	<CAA9_cmcNeg4vR7Ft8YcPGZtacftDWjC=5mHs2ZRzu9yXoOAJiA@mail.gmail.com>
	<20160101085911.GA28407@mail.hallyn.com>
	<CAPcyv4iig_sujK=p0TbNjTmtv39N7a0HSqpVe8mLnfX9Es7zNA@mail.gmail.com>
	<20160101180633.GA30941@mail.hallyn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=intel-com.20150623.gappssmtp.com; s=20150623;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to
	:cc:content-type;
	bh=FCSeGTRLPgCt9vKFFZmjpMulPI6DCiIM8APS9NEl47E=;
	b=eEmdiHUXGwzATjNngCfwDh57YDAUr/JwU2kpFSrNQ2H/gztKW7XEW83ar6vudxsqUL
	6ojJ1jp/myo6FlKlWmiOE7oxVsYHPml+BRAe8r5QgtGhO8KoDy2xdNqEkUThJvBS6K3Q
	b9Feq4mEHW8YQ35xkRdWuQ9Q46WhbYJu24MOZKmcdhQTXm5I/u5E0I+EO2Ewm2rfTIZl
	+tECOAR/1IkD5n3UETgc64Zj8qJmfFb0rnGBqqJNYVoQvPPdkkunVTINJ8P9/UEntVh2
	irXAFlgrHmElIWXnk8rZ6YRiHlZzPiEJLY5nBYVT6esJw9Ep0tMyOdgDEtbGQ/HeII9D
	jCcQ==
In-Reply-To: <20160101180633.GA30941-7LNsyQBKDXoIagZqoN9o3w@public.gmane.org>
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
To: "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Cc: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, lxc-devel-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On Fri, Jan 1, 2016 at 10:06 AM, Serge E. Hallyn
<serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org> wrote:
> On Fri, Jan 01, 2016 at 01:42:57AM -0800, Dan Williams wrote:
>> Commit 54b39d263704 "cgroup: cgroup namespace setns support" not
>> booting is a separate issue.
>
> Oh - been there since my first version of the set (v4).  Odd, I
> thought that the automated korg testing caught those.
>
> What is the simplest way to fix this?  Do I send new versions of
> patches v3 and v4?  Does Tejun or Stephen just do it inline in the
> git tree?  Do we leave it be?

I'm assuming it can be fixed up when you re-spin the patches to fix
the boot failure.
