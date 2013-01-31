From: "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [PATCH v4 9/9] devcg: propagate local changes down the
 hierarchy
Date: Thu, 31 Jan 2013 04:38:39 +0000
Message-ID: <20130131043839.GA14726@mail.hallyn.com>
References: <20130130171101.060853036@napanee.usersys.redhat.com>
 <20130130171102.390708521@napanee.usersys.redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130130171102.390708521@napanee.usersys.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: aris@redhat.com
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Tejun Heo <tj@kernel.org>, Serge Hallyn <serge.hallyn@canonical.com>

Quoting aris@redhat.com (aris@redhat.com):
...
> New exceptions allowing additional access to devices won't be propagated, but
> it'll be possible to add an exception to access all of part of the newly
> allowed device(s).

Is that intended to apply only to only in the DEFAULT_DENY case?  If so
that should be made clear.  If not,

...

> @@ -515,11 +673,13 @@ 	memset(&ex, 0, sizeof(ex));
>  							 &parent->exceptions);
>  			devcgroup->behavior = DEVCG_DEFAULT_ALLOW;
>  			devcgroup->local.behavior = DEVCG_DEFAULT_ALLOW;
> +			rc = propagate_behavior(devcgroup);
>  			break;
>  		case DEVCG_DENY:
>  			dev_exception_clean_all(devcgroup);
>  			devcgroup->behavior = DEVCG_DEFAULT_DENY;
>  			devcgroup->local.behavior = DEVCG_DEFAULT_DENY;
> +			rc = propagate_behavior(devcgroup);
>  			break;
>  		default:
>  			rc = -EINVAL;
> @@ -610,9 +770,14 @@ 		case '\0':
>  		 */
>  		if (devcgroup->behavior == DEVCG_DEFAULT_ALLOW) {
>  			dev_exception_rm(devcgroup, &ex);
> -			return 0;
> +			rc = propagate_exception(devcgroup);

Let's say the default in both parent A and child B is ALLOW, and both
have a blacklist entry for "b 8:* rwm".  Now I

	echo "b 8:* rwm" > A/devices.allow

removing the blacklist entry.  Here you are propagating that to the
child B, which I would argue is actually propagating a new allow to
a child.  Which you said you wouldn't do.

> +			return rc;
>  		}
> -		return dev_exception_add(devcgroup, &ex);
> +		rc = dev_exception_add(devcgroup, &ex);
> +		if (!rc)
> +			/* if a local behavior wasn't explicitely choosen, pick it */
> +			devcgroup->local.behavior = devcgroup->behavior;
> +		break;
>  	case DEVCG_DENY:
>  		/*
>  		 * If the default policy is to deny by default, try to remove
> @@ -621,13 +786,22 @@ 			return 0;
>  		 */
>  		if (devcgroup->behavior == DEVCG_DEFAULT_DENY) {
>  			dev_exception_rm(devcgroup, &ex);
> -			return 0;
> +			rc = propagate_exception(devcgroup);
> +			return rc;
>  		}
> -		return dev_exception_add(devcgroup, &ex);
> +		rc = dev_exception_add(devcgroup, &ex);
> +		if (rc)
> +			return rc;
> +		/* we only propagate new restrictions */
> +		rc = propagate_exception(devcgroup);
> +		if (!rc)
> +			/* if a local behavior wasn't explicitely choosen, pick it */
> +			devcgroup->local.behavior = devcgroup->behavior;
> +		break;
