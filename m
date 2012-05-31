From: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] meminfo: show /proc/meminfo base on container's memcg
Date: Wed, 30 May 2012 23:17:51 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.1205302314190.25774@chino.kir.corp.google.com>
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
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20120113;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
	:references:user-agent:mime-version:content-type;
	bh=cPGo7JSTnlddESCVMFnmeD6A2BYx3vjOknBjU47b/m4=;
	b=LDgPTPtMhjRxIlQ8WSvcq0j/cWQFzCTO2+ZZRNGFvcBj/h1Pb2kWf3MrClCGmEyohM
	03x6+YyOw41j+Yh9DzUsM2PUWZMpDRb68LqclDnkUqApjA9yqNGqn953M6HdeDxL15M3
	Ipoge94x+qBMVcEPdvda4zIjMPw6apvOC1LhnaXiRVLx4NCk4AMgAN0hWiFyttGqHUNp
	pjBvYOFqtfLpv59I6PmDpgm/+/WkGOBCbS37rvgvoCl4LOlF3Bt+6NEIWNp3Ahcpa/MZ
	/Enz1SGMRcatHexWoDUwCzSyf26Fbjtqzltzkt8xJCtra8IocT10DXFRNmlEq6vvLEKz
	RR6g==
In-Reply-To: <4FC70355.70805-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
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
To: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, KOSAKI Motohiro <kosaki.motohiro-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org

On Thu, 31 May 2012, Kamezawa Hiroyuki wrote:

> > The bottomline is that /proc/meminfo is one of many global resource state
> > interfaces and doesn't imply that every thread has access to the full
> > resources.  It never has.  It's very simple for another thread to consume
> > a large amount of memory as soon as your read() of /proc/meminfo completes
> > and then that information is completely bogus.
> 
> Why you need to discuss this here ? We know all information are snapshot.
> 

MemTotal is usually assumed to be static from /proc/meminfo and could now 
change radically without notification to the application.

> Hmm....maybe need to mount cgroup in the container (again) and get an access
> to cgroup
> hierarchy and find the cgroup it belongs to......if it's allowed.

An application should always know the cgroup that its attached to and be 
able to read its state using the command that I gave earlier.
