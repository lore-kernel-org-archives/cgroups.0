From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET] cgroup, memcg: introduce sane_behavior mount option
Date: Sun, 14 Apr 2013 20:17:54 -0700
Message-ID: <20130415031754.GG3050@htj.dyndns.org>
References: <1365808259-31073-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=x-received:sender:date:from:to:cc:subject:message-id:references
	:mime-version:content-type:content-disposition:in-reply-to
	:user-agent; bh=1jGpvejFEsQIBpRG0b1EvRnHoaRU3Dq4JafNhSb6Ox0=;
	b=pPH9kgLlcf7Jl2Lljp94/agn3mtTecq6UscWuEC3y3FjxHsyRZM+4LYhGrubPPryjs
	+V+iZpdG6SeJbLzTbky6KFSNQDRujzNtL4+WwJAuwcOid+dpDNFf1M8buzUB43MJxJB/
	9qDFYPrf1dl9ZJzYWTZRFfpx18r14YTdDqVcImiv94uW84redAVffaspiBjmPcR8NKR6
	bmZv3MLYTb9Om41ok799Thj0egqH4pnTEqwIzOYVoh5dlTmIOrvasWoHwPZfHq+wP/jv
	sP+64kECRBa2KQCKVf2uTL3zJneVytT1g5K6ps1TmkHRQ03ASQxJIIFSMhpiDqmt0Pzh
	RRpQ==
Content-Disposition: inline
In-Reply-To: <1365808259-31073-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
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
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Apr 12, 2013 at 04:10:55PM -0700, Tejun Heo wrote:
> To make progress, those behaviors need to go but we can't simply drop
> or change the crazies as those are directly visible to userland.  This
> patchset implements a mount option - sane_behavior - which turns on
> new saner behaviors, so that we can keep providing the old behaviors
> while and after transitioning to saner ones.

Applied 1-3 to cgroup/for-3.10.  Michal, I left the last memcg one
out.  Please let me know how you wanna route it.

Thanks.

-- 
tejun
