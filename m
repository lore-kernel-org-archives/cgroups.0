From: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2.6.32] memcg: warn on deeper hierarchies with
	use_hierarchy==0
Date: Thu, 20 Sep 2012 15:33:23 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.1209201531250.17455@chino.kir.corp.google.com>
References: <20120913205827.GO7677@google.com>
	<20120914150306.GQ28039@dhcp22.suse.cz>
	<20120919140203.GA5398@dhcp22.suse.cz>
	<20120919140308.GB5398@dhcp22.suse.cz>
	<alpine.DEB.2.00.1209191237020.749@chino.kir.corp.google.com>
	<20120920132400.GC23872@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20120113;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
	:references:user-agent:mime-version:content-type;
	bh=QMpE85IsxGmnzxVc67FbYNtX1fGiNYj9VC/JoO6qhew=;
	b=YgUhscnNbNPbVhXbGGw5/wXMLUNct2qXzMsNMQ3WBKY7qhwpkruiWeMnxq4kAFvtNI
	71Fl2FMW0XHvEJXqQQgU+PiCZnAEGVE0DJ34jtTHI9JqNWj+4lFscB3YQ/qX5vY+xs8A
	OMYWQSS9RlQ3239UMBex0Crbf9fR2a74semjsRqsvYN9EMX26RYkzMsw/fPkTz1kDm7H
	dTHShsm7d4rVesJDxSJwVQhB3U0FhjrV9+eWvH5hpT7wr0OX/SKoEH/nKcarQ4wGETJh
	S4ZNY/PpcfcNt2LpZnCIgYdAkgcgQLFYju1328ZduPWSBBcBMBm8vHg7lrS4Ni7/Br0+
	Czlg==
In-Reply-To: <20120920132400.GC23872-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
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
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Dave Jones <davej-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Neil Horman <nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>, "Serge E. Hallyn" <serue-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Graf <tgraf-G/eBtMaohhA@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Arnaldo Carvalho de Melo <acme-f8uhVLnGfZaxAyOMLChx1axOck334EZe@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Thu, 20 Sep 2012, Michal Hocko wrote:

> Yes printk_once is an alternative but I really wanted to have this as
> much visible as possible. People tend to react to stack traceces more
> and this one will trigger only if somebody is either doing something
> wrong or the configuration is the one we are looking for.
> 

That's the complete opposite of what Linus has said he wants, he said very 
specifically that he doesn't want WARN_ONCE() or WARN_ON_ONCE() for 
deprecation of tunables.  If you want to have this merged, then please get 
him to ack it.

> Comparing to oom_adj, that one was used much more often so the WARN_ONCE
> was too verbose especially when you usually had to wait for an userspace
> update which is not the case here.

How is WARN_ONCE() too verbose for oom_adj?  It's printed once!  And how 
can you claim that userspace doesn't need to change if it's creating a 
hierarchy while use_hierarchy == 0?
