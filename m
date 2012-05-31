From: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] meminfo: show /proc/meminfo base on container's memcg
Date: Wed, 30 May 2012 23:28:54 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.1205302325500.25774@chino.kir.corp.google.com>
References: <1338260214-21919-1-git-send-email-gaofeng@cn.fujitsu.com>
	<alpine.DEB.2.00.1205301433490.9716@chino.kir.corp.google.com>
	<4FC6B68C.2070703@jp.fujitsu.com>
	<CAHGf_=pFbsy4FO_UNu6O1-KyTd6O=pkmR8=3EGuZB5Reu3Vb9w@mail.gmail.com>
	<4FC6BC3E.5010807@jp.fujitsu.com>
	<alpine.DEB.2.00.1205301737530.25774@chino.kir.corp.google.com>
	<4FC6C111.2060108@jp.fujitsu.com>
	<alpine.DEB.2.00.1205301831270.25774@chino.kir.corp.google.com>
	<4FC6D881.4090706@jp.fujitsu.com>
	<alpine.DEB.2.00.1205302156090.25774@chino.kir.corp.google.com>
	<4FC70355.70805@jp.fujitsu.com>
	<alpine.DEB.2.00.1205302314190.25774@chino.kir.corp.google.com>
	<4FC70E5E.1010003@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20120113;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
	:references:user-agent:mime-version:content-type;
	bh=AAxpQXAStQVNFenTSXFZuwgl+3G8UGqDGqHVkSaMQNw=;
	b=JCcQ3zkwS9EzKhy9KmmjXWwYT4HU+zCLPYJAaAltbCPAGBliLVF0Mbj67Zxp3E820s
	fk3jAi1mhORhchPBnJQD6Ap6dbgMuSL8tDMxDM2A01/tDn3CTJ3aOsSeSeXGW1NOpRMb
	d7SrkFjz58BCfZD1Fwjg+4BXY5oHdRHLHuqp2eqeQiBJdCwOEj1dahg6tFjYX+4ezBX4
	tq8XvLbTJoaMh08blIcTExZpjiCn5BhxWGBUdVB294Q84A5g55gaqvqier2ivkcK1AOS
	UNZEgewp38j2jPQnPy4zdm+ZoUfZXo0zl4/fRWTVNS3dIBL0Dm7EDYgYZVgedsTvFgal
	5B4A==
In-Reply-To: <4FC70E5E.1010003-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
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
To: KOSAKI Motohiro <kosaki.motohiro-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org

On Thu, 31 May 2012, KOSAKI Motohiro wrote:

> > An application should always know the cgroup that its attached to and be
> > able to read its state using the command that I gave earlier.
> 
> No. you don't need why userland folks want namespaces. Even though you don't
> need namespaces. It doesn't good reason to refuse another use case.
> 

This is tangent to the discussion, we need to revisit why an application 
other than a daemon managing a set of memcgs would ever need to know the 
information in /proc/meminfo.  No use-case was ever presented in the 
changelog and its not clear how this is at all relevant.  So before 
changing the kernel, please describe how this actually matters in a real-
world scenario.
