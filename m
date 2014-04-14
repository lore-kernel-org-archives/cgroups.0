From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET cgroup/for-3.16] cgroup: implement cgroup.populated
Date: Mon, 14 Apr 2014 17:31:00 -0400
Message-ID: <20140414213100.GA1863@htj.dyndns.org>
References: <1397056052-2829-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=sender:date:from:to:cc:subject:message-id:references:mime-version
	:content-type:content-disposition:in-reply-to:user-agent;
	bh=i2U0RVmHfhUkOvM+bxB+SGxoDs7WkmSVp8qpesgJoyg=;
	b=Me6Lj/7azO1WsVzxRtp9KJXkt7buWVrSYU3qxQ9ePw+y4cOM/S3cAaEqH82t8KIfWg
	B960vUUHIXf246rrpn3Su2P6C9fboin7HLFOl+uX9RjCtVIhzfoX2zO0BXPgPXJLt+q+
	a0HsZ8RDXLtKMyu1k7sLLKbHjccn/W+G8Le/3QpO9E2BFhSbnB/Y1kgY33S9l+dFzo1O
	QarnxGF62VdbvL2lhzOHD1zBgjIpnAu8DhCjW+OTGZ815WVWz8znJhugf+xpPldx/oP3
	PjUL5fCK0FCpIhZcC1OmKB+HzzKOCRHo/ldPfvfeqgeqg3QbOjCwt6/QPgViRhbWJL7h
	XQYQ==
Content-Disposition: inline
In-Reply-To: <1397056052-2829-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
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
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org
Cc: rlove-L7G0xEPcOZbYtjvyW6yDsg@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org, kay-tD+1rO4QERM@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lennart-mdGvqq1h2p+GdvJs77BJ7Q@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org, john-jueV0HHMeujJJrXXpGQQMAC/G2K4zDHf@public.gmane.org

On Wed, Apr 09, 2014 at 11:07:29AM -0400, Tejun Heo wrote:
> This patchset is on top of "cgroup: implement unified hierarchy"
> patchset[1] and availalbe in the following git branch.
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-populated

Branch renamed to review-populated-v1.

Thanks.

-- 
tejun
