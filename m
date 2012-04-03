From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET] cgroup: cftype based file interface, take #2
Date: Tue, 3 Apr 2012 11:47:19 -0700
Message-ID: <20120403184719.GB27794@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1332368265-21586-1-git-send-email-tj@kernel.org>
	<20120330222936.GI28934@google.com>
	<4F7A6D13.4060704@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=sender:date:from:to:cc:subject:message-id:references:mime-version
	:content-type:content-disposition:in-reply-to:user-agent;
	bh=qYH3fWLx/lveZo3QdzYy2e4nh5XqfO40UoZ49dpSVI4=;
	b=cbVgBOuQBjwDDuALvxenc9Tb/YheuLFoQC6I/RHGEHCTbRDnGxGXt5Zfa7RDQPioUJ
	+yyIy+ydIhHWY04vhVrH4mzW8LxVVuNZxzar3BeRWyHg1SXdTO1qKVg7rGPpyAUr7Klv
	6zI3tlDtgzwb64yx+51YFMjoNafHwQKgw8F14AfRq3gIc59t62WA0iuoE21jn8Ommt10
	iEkVT+LlzDcZ7j9LXDptx68lvJvednHZqn5hqMiELxkE82ox/wjqVUJlljaecpuHrvFS
	CjfMFsPSMcD0LSoI0XMuFicEO9Xg5X0b90m38ZkxvBBW7v4Sb9BqbUqyJuIFxArId/aZ
	nYVQ==
Content-Disposition: inline
In-Reply-To: <4F7A6D13.4060704-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
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
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: ctalbott-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, rni-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Glauber.

On Tue, Apr 03, 2012 at 07:22:59AM +0400, Glauber Costa wrote:
> Do I need to send you a patch to remove memcg's populate on top of this ?

populate is already gone.  My memory is a bit fuzzy now.  Can you spot
something broken / to be improved re. memcg cftypes in the current
cgroup/for-3.5 branch?

Thanks.

-- 
tejun
