From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET] cgroup: simplify cgroup removal path
Date: Wed, 31 Oct 2012 10:26:17 -0700
Message-ID: <20121031172617.GK2945@htj.dyndns.org>
References: <1351657365-25055-1-git-send-email-tj@kernel.org>
	<50912C6D.6020000@parallels.com>
	<20121031171849.GH2945@htj.dyndns.org>
	<50915EB6.3060704@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=sender:date:from:to:cc:subject:message-id:references:mime-version
	:content-type:content-disposition:in-reply-to:user-agent;
	bh=a2TPYKkDwT5neRMMmfWlIIA1EPUeRMPVFO2JUohBHD0=;
	b=DWn4gvZ6GLaAniZPWz5+ac4N57hZyE6m7bWV8K9PjhNwuNck8vjdLLgUeIf01Y3piK
	ZXUQkLZz4p9kJZDUhovYsU6LqBMU4Ir/W/6SuHx0Xo+2e9iXnYYc1XQiPIS9c+8xsVip
	4ry1JmMvO7oawKBgcIzRA59L+rsPtCqcVKfN7NqmfhCzp+y1NSWZsjUtce9LoKC3w2Dk
	Bg3yq07Z8Kb1LY6vfuiGdTArKkmM2wNVKTPfNzvJa1mUXGHCVPpjARQCRzHDz2lITHL2
	XiXg2Mr2o7TZaC9W3qf595F8FhCWT0le4PpcrWrqABpUQ2dvj5SyrqFAMk5j8oz8CYlm
	TraA==
Content-Disposition: inline
In-Reply-To: <50915EB6.3060704-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
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
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org

On Wed, Oct 31, 2012 at 09:24:06PM +0400, Glauber Costa wrote:
> > Note both in the commit messages.
> 
> I am sorry, but I can't find anything that may be related to this in the
> commit messages. Can you be more specific ?

Eh.. 'd', missing there.  I meant that I noted both in the updated
commit messages, so they will be mentioned in commit messages on the
next posting of this series.

Thanks.

-- 
tejun
